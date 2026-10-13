package ${package}.gun_maker;

import java.util.HashMap;
import java.util.Map;

import net.neoforged.neoforge.network.handling.IPayloadContext;
import net.neoforged.neoforge.network.event.RegisterPayloadHandlersEvent;
import net.neoforged.neoforge.network.PacketDistributor;
import net.neoforged.neoforge.event.tick.PlayerTickEvent;
import net.neoforged.neoforge.client.event.RenderPlayerEvent;
import net.neoforged.neoforge.client.event.ClientTickEvent;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.api.distmarker.Dist;

import net.minecraft.world.level.Level;
import net.minecraft.world.item.component.CustomData;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Item;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.Entity;
import net.minecraft.tags.TagKey;
import net.minecraft.tags.ItemTags;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.network.protocol.common.custom.CustomPacketPayload;
import net.minecraft.network.codec.StreamCodec;
import net.minecraft.network.codec.ByteBufCodecs;
import net.minecraft.network.RegistryFriendlyByteBuf;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.core.component.DataComponents;
import net.minecraft.client.model.HumanoidModel;
import net.minecraft.client.Minecraft;

/**
 * Main is the core utility class for managing gun logic values in the Gun Maker plugin.
 * It was created be hacker_E303, the plugin author.
 * 
 * This class handles both item stack-specific values and entity-specific values, making it
 * versatile for different gun-related mechanics in the game.
 */
public class GunMaker {

	// The plugin properties
	public static class Plugin {

		public static final String LOADER = "neoforge";
		
		public static final String ID = "gun_maker_plugin";
		public static final String NAME = "Gun Maker Plugin";
		public static final String AUTHOR = "hacker_E303";

		// Logger for logging errors
		public static final org.apache.logging.log4j.Logger LOGGER = org.apache.logging.log4j.LogManager.getLogger(NAME);
	}

	// The gun utils/tools
	public static class GunUtils {

		// Numeric values representing gun properties

		public static final Value LEVEL = new Value("gun_maker_00", Integer.class);
		public static final Value AMMO_NUMBER = new Value("gun_maker_01", Integer.class);
		public static final Value MAX_AMMO_NUMBER = new Value("gun_maker_02", Integer.class);
		public static final Value RECOVERY_TIME = new Value("gun_maker_03", Integer.class);
		public static final Value SHOOTED_ROUNDS = new Value("gun_maker_04", Integer.class);
		public static final Value ACCUMULATED_INACCURACY = new Value("gun_maker_05",  Double.class);

		// Boolean values representing gun states

		public static final Value IS_AIMING = new Value("gun_maker_06", Boolean.class);
		public static final Value IS_SHOOTING = new Value("gun_maker_07", Boolean.class);
		public static final Value IS_RELOADING = new Value("gun_maker_08", Boolean.class);
		public static final Value SHOULD_SHOOT = new Value("gun_maker_09", Boolean.class);

		public static final Value MOUSE_LEFT = new Value("gun_maker_10", Boolean.class);
		public static final Value MOUSE_RIGHT = new Value("gun_maker_11", Boolean.class);
		public static final Value HAS_SHOOTED = new Value("gun_maker_12", Boolean.class);

		private static final TagKey<Item> GUNS = ItemTags.create(ResourceLocation.fromNamespaceAndPath(Plugin.LOADER, "guns"));
		
		/**
		* Checks if the provided ItemStack is a gun by checking the "guns" item tag.
		* 
		* @param stack The ItemStack to check
		* @return true if the ItemStack is in the "neoforge:guns" tag, false otherwise
		*/
		public static boolean isGun(ItemStack stack) {
			return stack.is(GUNS);
		}

		/**
		* Sets a value on an ItemStack's persistent data store using the CUSTOM_DATA component.
		* 
		* @param stack The ItemStack to set the value on
		* @param value The Value definition specifying the key and type
		* @param obj The value to set (must match the type specified by the Value definition)
		*/
		public static void setValue(ItemStack stack, Value value, Object obj) {
			CompoundTag tag = getCompoundTag(stack);
			setValue(tag, value, obj);
			setCompoundTag(stack, tag);
		}

		/**
		* Gets a value from an ItemStack's persistent data store.
		* 
		* @param stack The ItemStack to get the value from
		* @param value The Value definition specifying the key and type
		* @return The value from the ItemStack's CUSTOM_DATA component, or null if not found
		*/
		public static Object getValue(ItemStack stack, Value value) {
			return getValue(getCompoundTag(stack), value);
		}

		/**
		* Gets the custom data CompoundTag from an ItemStack's CUSTOM_DATA component.
		* Returns a copy of the tag, so modifications must be saved back via setCompoundTag().
		* 
		* @param stack The ItemStack to get the CompoundTag from
		* @return A copy of the CompoundTag stored in the ItemStack's CUSTOM_DATA component
		*/
		private static CompoundTag getCompoundTag(ItemStack stack) {
			CustomData customData = stack.getOrDefault(DataComponents.CUSTOM_DATA, CustomData.EMPTY);
			return customData.copyTag();
		}

		/**
		* Saves the CompoundTag back to the ItemStack's CUSTOM_DATA component.
		* 
		* @param stack The ItemStack to save the tag to
		* @param tag The CompoundTag to store in the ItemStack's CUSTOM_DATA component
		*/
		private static void setCompoundTag(ItemStack stack, CompoundTag tag) {
			stack.set(DataComponents.CUSTOM_DATA, CustomData.of(tag));
		}

		/**
		* Sets a value on an Entity's persistent data store.
		* 
		* @param entity The Entity to set the value on
		* @param value The Value definition specifying the key and type
		* @param obj The value to set (must match the type specified by the Value definition)
		*/
		public static void setValue(Entity entity, Value value, Object obj) {
			setValue(getCompoundTag(entity), value, obj);
		}

		/**
		* Gets a value from an Entity's persistent data store.
		* 
		* @param entity The Entity to get the value from
		* @param value The Value definition specifying the key and type
		* @return The value from the Entity's persistent data, or null if not found
		*/
		public static Object getValue(Entity entity, Value value) {
			return getValue(getCompoundTag(entity), value);
		}

		/**
		* Gets the persistent data CompoundTag from an Entity.
		* Unlike ItemStacks, Entities still use the old NBT system directly.
		* 
		* @param entity The Entity to get the CompoundTag from
		* @return The Entity's persistent data CompoundTag
		*/
		private static CompoundTag getCompoundTag(Entity entity) {
			return entity.getPersistentData();
		}

		/**
		* Internal helper method to set a value on a CompoundTag.
		* Handles type checking and conversion for supported data types.
		* 
		* @param tag The CompoundTag to set the value on
		* @param value The Value definition specifying the key and type
		* @param obj The value to set (must match the type specified by the Value definition)
		*/
		private static void setValue(CompoundTag tag, Value value, Object obj) {
			String name = value.getName();
			Class<?> type = value.getType();

			if (!name.isEmpty()) {
				if (type == Boolean.class  && obj instanceof Boolean data) tag.putBoolean(name, data.booleanValue());
				else if (type == Integer.class && obj instanceof Number index) tag.putInt(name, index.intValue());
				else if (type == Double.class && obj instanceof Number index) tag.putDouble(name, index.doubleValue());
				else if (type == Float.class && obj instanceof Number index) tag.putFloat(name, index.floatValue());
				else printError(0);
			} else printError(0);
		}

		/**
		* Internal helper method to get a value from a CompoundTag.
		* Handles type checking and conversion for supported data types.
		* 
		* @param tag The CompoundTag to get the value from
		* @param value The Value definition specifying the key and type
		* @return The value from the CompoundTag, or null if an error occurs
		*/
		private static Object getValue(CompoundTag tag, Value value) {
			String name = value.getName();
			Class<?> type = value.getType();

			if (!name.isEmpty()) {
				if (type == Boolean.class) return tag.getBoolean(name);
				else if (type == Integer.class) return tag.getInt(name);
				else if (type == Double.class) return tag.getDouble(name);
				else if (type == Float.class) return tag.getFloat(name);
				else printError(0);
			}
			printError(0);
			return null;
		}
	}

	/**
	 * Value is an internal helper class that defines the structure of gun logic values.
	 * It encapsulates the name (key) and type information for each value stored in persistent data.
	 */
	private static class Value {

		private final String VALUE_NAME;
		private final Class<?> VALUE_TYPE;

		/**
		 * Creates a new Value definition.
		 * 
		 * @param valueName The name/key for the value (used in persistent data storage)
		 * @param valueType The Java type of the value
		 */
		public Value(String valueName, Class<?> valueType) {
			this.VALUE_NAME = valueName;
			this.VALUE_TYPE = valueType;
		}

		/**
		 * Gets the name/key of the value.
		 * 
		 * @return The name/key of the value
		 */
		public String getName() {
			if (!VALUE_NAME.isEmpty()) return VALUE_NAME;

			printError(0); 
			return ""; 
		}

		/**
		* Gets the Java type of the value.
		* 
		* @return The Java type of the value
		*/
		public Class<?> getType() {
			if (VALUE_TYPE != null) return VALUE_TYPE;

			printError(0); 
			return null; 
		}
	}

	/**
	 * Prints predefined error messages to the console.
	 * 
	 * @param index The error index to print (maps to predefined error messages)
	 */
	public static void printError(int index) {

		String errorType;
		String errorMessage;

    	switch (index) {
    	    case 0: 	
    	    	errorType = "INVALID_VALUE";
    	    	errorMessage = "The provided value is not mapped.";
    	    	break;
			case 1:     
				errorType = "INVALID_PROCEDURE";
				errorMessage = "Gun definition procedure blocks need the 'Gun Definitions' global trigger!";
				break;
    	    default: 	
    	    	errorType = "UNKNOWN_ERROR";
    	    	errorMessage = "Index out of bounds! No right error message was found to send.";
    	    	break;
    	}
    	String finalError = errorType + ": " + errorMessage;
    	Plugin.LOGGER.error(finalError);
	}

	/**
	 * Events class contains all the event handlers for the Gun Maker plugin.
	 * These handlers manage various gun-related mechanics when specific game events occur.
	 */
	@EventBusSubscriber(modid = "${modid}")
	public static class Events {

		<#if no_swing>
		   	// Tracks the last held item to detect when the player switches items
		   	private static ItemStack LAST_ITEM = ItemStack.EMPTY;

			/**
			 * Handles player tick events to adjust player attributes when holding a gun.
			 * Modifies block reach, entity reach, and attack speed based on whether the player is holding a gun.
			 *
			 * @param event The PlayerTickEvent containing tick and player information
			 */
			@SubscribeEvent
		   	public static void onPlayerTick(PlayerTickEvent.Post event) {

		       	if (event.getEntity() == null) return;
				LivingEntity living = (LivingEntity) event.getEntity();

		   	    if (living.level().isClientSide) return;
		   	    ItemStack CURRENT_ITEM = living.getMainHandItem();

		   	    if (CURRENT_ITEM != LAST_ITEM) {

		   	        if (GunUtils.isGun(CURRENT_ITEM) && CURRENT_ITEM != ItemStack.EMPTY) {

					    living.getAttribute(Attributes.BLOCK_INTERACTION_RANGE).setBaseValue(0);
					    living.getAttribute(Attributes.ENTITY_INTERACTION_RANGE).setBaseValue(0);
					    living.getAttribute(Attributes.ATTACK_SPEED).setBaseValue(1024D);

		       	    } else if (!GunUtils.isGun(CURRENT_ITEM) || CURRENT_ITEM == ItemStack.EMPTY) {

		       	        living.getAttribute(Attributes.BLOCK_INTERACTION_RANGE).setBaseValue(4.5D);
					    living.getAttribute(Attributes.ENTITY_INTERACTION_RANGE).setBaseValue(3D);
					    living.getAttribute(Attributes.ATTACK_SPEED).setBaseValue(4D);
		       	    }
		       	}
		       	LAST_ITEM = living.getMainHandItem().copy();
		   	}
		</#if>

		<#if gun_pose || no_swing>

			<#if gun_pose>
		   		// Cache for tracking currently held items per player (entity ID -> main hand item)
		   		// Used in RenderPlayerEvent.Pre where the entity reference is not available in 1.21.4+
		   		private static final Map<Integer, ItemStack> PLAYER_HELD_ITEMS = new HashMap<>();
			</#if>

		   	/**
		     * Handles client tick events to prevent weapon swinging animation when holding a gun.
		     * This ensures guns have a more appropriate idle animation.
		     * Also updates the held item cache for arm pose modification.
		     *
		     * @param event The ClientTickEvent containing tick information
		     */
		    @SubscribeEvent
		    public static void onClientTick(ClientTickEvent.Post event) {

		        Level level = Minecraft.getInstance().level;
		        if (level == null) return;

		        for (Player player : level.players()) {

					<#if gun_pose>
					PLAYER_HELD_ITEMS.put(player.getId(), player.getMainHandItem());
					</#if>
					<#if no_swing>
					if (GunUtils.isGun(player.getMainHandItem())) player.swinging = false;
					</#if>
				}
		    }
		</#if>

		<#if gun_pose>
		   /**
		    * Handles render player events to change the player's arm pose when holding a gun.
		    * Sets the right arm pose to the bow and arrow pose, which looks appropriate for holding a gun.
		    * In NeoForge 1.21.4+, the entity reference is no longer available via event.getEntity(),
		    * so we use the PLAYER_HELD_ITEMS cache and set the arm pose on the render state directly.
		    * The render state's rightArmPose is read by setupAnim() after this event fires.
		    *
		    * @param event The RenderPlayerEvent.Pre containing rendering and player information
		    */
		   @EventBusSubscriber(modid = "${modid}")
		   public static class ClientRenderEvents {
		       @SubscribeEvent
		       public static void onEventTriggered(RenderPlayerEvent.Pre event) {
		           int entityId = event.getRenderState().id;
		           ItemStack stack = PLAYER_HELD_ITEMS.getOrDefault(entityId, ItemStack.EMPTY);
		           if (GunUtils.isGun(stack)) {

		               <#if gun_pose_active>
		               event.getRenderState().rightArmPose = HumanoidModel.ArmPose.BOW_AND_ARROW;
		               <#else>

		               if ((boolean) GunUtils.getValue(stack, GunUtils.IS_AIMING))
		                   event.getRenderState().rightArmPose = HumanoidModel.ArmPose.BOW_AND_ARROW;
		               </#if>
		           }
		       }
		   }
		</#if>

        private static boolean lastLeft  = false;
        private static boolean lastRight = false;

		/**
         * Listens for client-side ticks to detect mouse input changes.
         * If the mouse state changes, it synchronizes the data with the server.
         */
        @SubscribeEvent
        public static void onClientMouseTick(ClientTickEvent.Post event) {
            if (Minecraft.getInstance().player != null) {
                
                boolean left  = Minecraft.getInstance().mouseHandler.isLeftPressed();
                boolean right = Minecraft.getInstance().mouseHandler.isRightPressed();
    
                if (left != lastLeft || right != lastRight) {
                    PacketDistributor.sendToServer(new PacketHandler.MouseClickPacket(left, right));
                    lastLeft  = left;
                    lastRight = right;
                }
            }
        }
    }

    /**
     * PacketHandler manages the networking system for the Gun Maker plugin.
     * It registers the network channel and handles incoming packets from clients.
     */
    @SuppressWarnings("deprecation")
    @EventBusSubscriber(modid = "${modid}")
    public static class PacketHandler {
        
        public record MouseClickPacket(boolean leftClick, boolean rightClick) implements CustomPacketPayload {
            
            public static final Type<MouseClickPacket> TYPE = 
                new Type<>(ResourceLocation.fromNamespaceAndPath("${modid}", "main_channel"));
            
            public static final StreamCodec<RegistryFriendlyByteBuf, MouseClickPacket> STREAM_CODEC = StreamCodec.composite(
                ByteBufCodecs.BOOL, MouseClickPacket::leftClick,
                ByteBufCodecs.BOOL, MouseClickPacket::rightClick,
                MouseClickPacket::new
            );

            @Override
            public Type<? extends CustomPacketPayload> type() {
                return TYPE;
            }
        }

        public static void handleMouseClick(MouseClickPacket msg, IPayloadContext context) {
            context.enqueueWork(() -> {
                if (context.player() instanceof ServerPlayer player) {
                    GunUtils.setValue(player, GunUtils.MOUSE_LEFT, msg.leftClick());
                    GunUtils.setValue(player, GunUtils.MOUSE_RIGHT, msg.rightClick());
                }
            });
        }
    
        @SubscribeEvent
        public static void register(RegisterPayloadHandlersEvent event) {
            event.registrar("1").playToServer(
                MouseClickPacket.TYPE,
                MouseClickPacket.STREAM_CODEC,
                PacketHandler::handleMouseClick
            );
        }
    }
}