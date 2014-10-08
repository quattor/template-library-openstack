unique template features/messagebus/service;

# Include RPMs
include { 'features/messagebus/service/rpms/config' };

# Configure messagebus service
include { 'feature/messagebus/config' };
