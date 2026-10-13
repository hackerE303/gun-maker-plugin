package ${package}.gun_maker;

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

		public static final String LOADER 					= "forge";
		
		public static final String ID 						= "gun_maker_plugin";
		public static final String NAME 					= "Gun Maker Plugin";
		public static final String AUTHOR 					= "hacker_E303";

		// Logger for logging errors
		public static final org.apache.logging.log4j.Logger LOGGER = org.apache.logging.log4j.LogManager.getLogger(NAME);
	}

	// The gun utils/tools
	public static class GunUtils {

		// Numeric values representing gun properties

		public static final Value LEVEL 					= new Value("gun_maker_00", Integer.class);
		public static final Value AMMO_NUMBER 				= new Value("gun_maker_01", Integer.class);
		public static final Value MAX_AMMO_NUMBER 			= new Value("gun_maker_02", Integer.class);
		public static final Value RECOVERY_TIME 			= new Value("gun_maker_03", Integer.class);
		public static final Value SHOOTED_ROUNDS 			= new Value("gun_maker_04", Integer.class);
		public static final Value ACCUMULATED_INACCURACY 	= new Value("gun_maker_05",  Double.class);

		// Boolean values representing gun states

		public static final Value IS_AIMING 				= new Value("gun_maker_06", Boolean.class);
		public static final Value IS_SHOOTING		 		= new Value("gun_maker_07", Boolean.class);
		public static final Value IS_RELOADING		 		= new Value("gun_maker_08", Boolean.class);
		public static final Value SHOULD_SHOOT 				= new Value("gun_maker_09", Boolean.class);

		public static final Value MOUSE_LEFT 				= new Value("gun_maker_10", Boolean.class);
		public static final Value MOUSE_RIGHT 				= new Value("gun_maker_11", Boolean.class);
		public static final Value HAS_SHOOTED 				= new Value("gun_maker_12", Boolean.class);

		private static final TagKey<Item> GUNS = ItemTags.create(new ResourceLocation(Plugin.LOADER, "guns"));
		
		/**
		* Checks if provided ItemStack is a gun
		* 
		* @param stack The Entity to get the CompoundTag for
		* @return If the ItemStack is a gun
		*/
		public static boolean isGun(ItemStack stack) {
			return stack.is(GUNS);
		}

		/**
		* Sets a value on an ItemStack's persistent data store.
		* 
		* @param stack The ItemStack to set the value on
		* @param value The Value definition specifying the key and type
		* @param obj The value to set (must match the type specified by the Value definition)
		*/
		public static void setValue(ItemStack stack, Value value, Object obj) {
			setValue(getCompoundTag(stack), value, obj);
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
		* Gets a value from an ItemStack's persistent data store.
		* 
		* @param stack The ItemStack to get the value from
		* @param value The Value definition specifying the key and type
		* @return The value from the ItemStack's persistent data store
		*/
		public static Object getValue(ItemStack stack, Value value) {
			return getValue(getCompoundTag(stack), value);
		}

		/**
		* Gets a value from an Entity's persistent data store.
		* 
		* @param entity The Entity to get the value from
		* @param value The Value definition specifying the key and type
		* @return The value from the Entity's persistent data store
		*/
		public static Object getValue(Entity entity, Value value) {
			return getValue(getCompoundTag(entity), value);
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
			String name 	= value.getName();
			Class<?> type 	= value.getType();

			if (!name.isEmpty()) {
				if (type == Boolean.class  && obj instanceof Boolean data) tag.putBoolean(name, data.booleanValue());

				else if (type == Integer.class && obj instanceof Number index) 	tag.putInt(name, index.intValue());
				else if (type == Double.class && obj instanceof Number index) 	tag.putDouble(name, index.doubleValue());
				else if (type == Float.class && obj instanceof Number index) 	tag.putFloat(name, index.floatValue());

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
			String name 	= value.getName();
			Class<?> type 	= value.getType();

			if (!name.isEmpty()) {
				if (type == Boolean.class) return tag.getBoolean(name);

				else if (type == Integer.class) return tag.getInt(name);
				else if (type == Double.class) 	return tag.getDouble(name);
				else if (type == Float.class) 	return tag.getFloat(name);

				else printError(0);
			}
			printError(0);
			return null;
		}

		/**
		* Gets or creates a persistent data tag for an ItemStack.
		* 
		* @param stack The ItemStack to get the CompoundTag for
		* @return The CompoundTag associated with the ItemStack
		*/
		private static CompoundTag getCompoundTag(ItemStack stack) {
			return stack.getOrCreateTag();
		}

		/**
		* Gets or creates a persistent data tag for an Entity.
		* 
		* @param entity The Entity to get the CompoundTag for
		* @return The CompoundTag associated with the Entity
		*/
		private static CompoundTag getCompoundTag(Entity entity) {
			return entity.getPersistentData();
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
	@Mod.EventBusSubscriber
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
    	public static void onPlayerTick(TickEvent.PlayerTickEvent event) {

        	if (event.player == null) return;
			LivingEntity living = (LivingEntity) event.player;

    	    if (living.level().isClientSide) return;
    	    ItemStack CURRENT_ITEM = living.getMainHandItem();

    	    if (CURRENT_ITEM != LAST_ITEM) {

    	        if (GunUtils.isGun(CURRENT_ITEM) && CURRENT_ITEM != ItemStack.EMPTY) {

				    living.getAttribute(ForgeMod.BLOCK_REACH.get()).setBaseValue(0);
				    living.getAttribute(ForgeMod.ENTITY_REACH.get()).setBaseValue(0);
				    living.getAttribute(Attributes.ATTACK_SPEED).setBaseValue(1024D);

        	    } else if (!GunUtils.isGun(CURRENT_ITEM) || CURRENT_ITEM == ItemStack.EMPTY) {

        	        living.getAttribute(ForgeMod.BLOCK_REACH.get()).setBaseValue(4.5D);
				    living.getAttribute(ForgeMod.ENTITY_REACH.get()).setBaseValue(3D);
				    living.getAttribute(Attributes.ATTACK_SPEED).setBaseValue(4D);
        	    }
        	}
        	LAST_ITEM = living.getMainHandItem().copy();
    	}

	    /**
	     * Handles client tick events to prevent weapon swinging animation when holding a gun.
	     * This ensures guns have a more appropriate idle animation.
	     * 
	     * @param event The ClientTickEvent containing tick information
	     */
	    @SubscribeEvent
	    public static void onClientTick(TickEvent.ClientTickEvent event) {

	        if (event.phase == TickEvent.Phase.END) {
	            Level level = Minecraft.getInstance().level;

	            if (level == null) return;
	            for (Player player : level.players()) {

	                if (GunUtils.isGun(player.getMainHandItem())) player.swinging = false;
	            }
	        }
	    }
		</#if>

		<#if gun_pose>
    	/**
    	 * Handles render player events to change the player's arm pose when holding a gun.
    	 * Sets the right arm pose to the bow and arrow pose, which looks appropriate for holding a gun.
    	 * 
    	 * @param event The RenderPlayerEvent.Pre containing rendering and player information
    	 */
    	@OnlyIn(Dist.CLIENT)
    	@SubscribeEvent
    	public static void onEventTriggered(RenderPlayerEvent.Pre event) {

        	Entity entity = event.getEntity();
        	ItemStack stack = ItemStack.EMPTY;

        	if (entity instanceof LivingEntity living) stack = living.getMainHandItem();
        	if (GunUtils.isGun(stack)
				<#if !gun_pose_active>
					&& (boolean) GunUtils.getValue(stack, GunUtils.IS_AIMING)
				</#if>) {

        	    PlayerModel<?> model = (PlayerModel<?>) event.getRenderer().getModel();
        	    model.rightArmPose = HumanoidModel.ArmPose.BOW_AND_ARROW;
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
        public static void onClientMouseTick(TickEvent.ClientTickEvent event) {
            if (event.phase == TickEvent.Phase.END && Minecraft.getInstance().player != null) {
                
                boolean left  = Minecraft.getInstance().mouseHandler.isLeftPressed();
                boolean right = Minecraft.getInstance().mouseHandler.isRightPressed();
    
                if (left != lastLeft || right != lastRight) {
                    PacketHandler.INSTANCE.sendToServer(new PacketHandler.MouseClickPacket(left, right));
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
    @Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD)
    public static class PacketHandler {
        
        private static final String PROTOCOL_VERSION = "1";
        public static final SimpleChannel INSTANCE = NetworkRegistry.newSimpleChannel(new ResourceLocation("${modid}", "main_channel"),
            
            () -> PROTOCOL_VERSION,
            PROTOCOL_VERSION::equals,
            PROTOCOL_VERSION::equals
        );
    
        private static int packetId = 0;
    
        /**
         * MouseClickPacket carries the boolean states of the left and right mouse buttons.
         */
        public static class MouseClickPacket {
            
            private final boolean leftClick;
            private final boolean rightClick;
    
            public MouseClickPacket(boolean left, boolean right) {
                
                this.leftClick = left;
                this.rightClick = right;
            }
    
            /**
             * Encodes the packet data into the byte buffer for transmission.
             */
            public static void encode(MouseClickPacket msg, FriendlyByteBuf buffer) {
                
                buffer.writeBoolean(msg.leftClick);
                buffer.writeBoolean(msg.rightClick);
            }
    
            /**
             * Decodes the packet data from the byte buffer upon arrival.
             */
            public static MouseClickPacket decode(FriendlyByteBuf buffer) {
                return new MouseClickPacket(buffer.readBoolean(), buffer.readBoolean());
            }
    
            /**
             * Handles the packet on the server side, updating the gun's NBT data.
             */
            public static void handle(MouseClickPacket msg, Supplier<NetworkEvent.Context> contextSupplier) {
                NetworkEvent.Context context = contextSupplier.get();
                context.enqueueWork(() -> {
    
                    ServerPlayer player = context.getSender();
                    if (player == null) return;
                    
					GunUtils mg = null;

                    mg.setValue(player, mg.MOUSE_LEFT, msg.leftClick);
                    mg.setValue(player, mg.MOUSE_RIGHT, msg.rightClick);
                });
                context.setPacketHandled(true);
            }
        }
    
        /**
         * Registers the network messages during the common setup phase.
         */
        @SubscribeEvent
        public static void onCommonSetup(FMLCommonSetupEvent event) {
            event.enqueueWork(() -> {
                INSTANCE.registerMessage(packetId++, MouseClickPacket.class, 
                    MouseClickPacket::encode, MouseClickPacket::decode, MouseClickPacket::handle);
            });
        }
    }
}