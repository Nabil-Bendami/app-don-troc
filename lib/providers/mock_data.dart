import 'package:uuid/uuid.dart';
import '../models/index.dart';

/// Mock/Sample Data for Demonstration Purposes
/// Used when database is empty for app presentation to clients

class MockDataGenerator {
  static const uuid = Uuid();

  /// Generate sample messages for demo
  static List<MessageModel> generateSampleMessages(String chatId) {
    final now = DateTime.now();
    return [
      MessageModel(
        id: uuid.v4(),
        chatId: chatId,
        senderId: 'user1',
        senderName: 'Ahmed Hassan',
        senderPhotoUrl: '',
        text: 'Hi, is this item still available?',
        createdAt: now.subtract(const Duration(minutes: 45)),
      ),
      MessageModel(
        id: uuid.v4(),
        chatId: chatId,
        senderId: 'user2',
        senderName: 'Fatima Ben',
        senderPhotoUrl: '',
        text: 'Yes! It\'s in great condition. When can you come see it?',
        createdAt: now.subtract(const Duration(minutes: 40)),
      ),
      MessageModel(
        id: uuid.v4(),
        chatId: chatId,
        senderId: 'user1',
        senderName: 'Ahmed Hassan',
        senderPhotoUrl: '',
        text: 'Maybe this weekend? Is that convenient for you?',
        createdAt: now.subtract(const Duration(minutes: 35)),
      ),
      MessageModel(
        id: uuid.v4(),
        chatId: chatId,
        senderId: 'user2',
        senderName: 'Fatima Ben',
        senderPhotoUrl: '',
        text:
            'Perfect! Saturday afternoon would be great. Let me send you my address.',
        createdAt: now.subtract(const Duration(minutes: 20)),
      ),
      MessageModel(
        id: uuid.v4(),
        chatId: chatId,
        senderId: 'user1',
        senderName: 'Ahmed Hassan',
        senderPhotoUrl: '',
        text: 'Excellent! Looking forward to it 😊',
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  /// Generate sample items for demo
  static List<ItemModel> generateSampleItems() {
    final now = DateTime.now();
    return [
      ItemModel(
        id: uuid.v4(),
        title: 'iPhone 13 Pro - 256GB',
        description:
            'Excellent condition iPhone 13 Pro in Sierra Blue. Comes with original box and charger. Never dropped or damaged.',
        category: 'Electronics',
        type: ItemType.troc,
        imageUrls: ['https://via.placeholder.com/300x300?text=iPhone+13'],
        userId: 'user1',
        userName: 'Ahmed Hassan',
        userPhotoUrl: null,
        location: 'Tunis, Tunisia',
        latitude: 36.8065,
        longitude: 10.1815,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'Leather Sofa - Nearly New',
        description:
            'Beautiful 3-seater leather sofa. Purchased 6 months ago but must sell due to space. Dark brown color, very comfortable.',
        category: 'Home & Furniture',
        type: ItemType.don,
        imageUrls: ['https://via.placeholder.com/300x300?text=Sofa'],
        userId: 'user2',
        userName: 'Fatima Ben',
        userPhotoUrl: null,
        location: 'Ariana, Tunisia',
        latitude: 36.8667,
        longitude: 10.1667,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'Mountain Bike - Trek series',
        description:
            'Professional grade mountain bike perfect for trail riding. 21-speed, recently serviced. All terrain tires in good condition.',
        category: 'Sports & Outdoors',
        type: ItemType.troc,
        imageUrls: ['https://via.placeholder.com/300x300?text=Mountain+Bike'],
        userId: 'user3',
        userName: 'Mohamed Ali',
        userPhotoUrl: null,
        location: 'Sousse, Tunisia',
        latitude: 35.8256,
        longitude: 10.6369,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'Books Collection - Self Development',
        description:
            'Set of 15 self-help and business development books. Including "Atomic Habits", "Think and Grow Rich", "The 7 Habits" and more.',
        category: 'Books & Media',
        type: ItemType.don,
        imageUrls: ['https://via.placeholder.com/300x300?text=Books'],
        userId: 'user4',
        userName: 'Noor Jasmine',
        userPhotoUrl: null,
        location: 'Sfax, Tunisia',
        latitude: 34.7413,
        longitude: 10.7606,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'DSLR Camera - Canon 200D',
        description:
            'Canon EOS 200D with 18-55mm kit lens. Comes with memory card, tripod, and camera bag. Perfect for photography beginners.',
        category: 'Electronics',
        type: ItemType.troc,
        imageUrls: ['https://via.placeholder.com/300x300?text=Camera'],
        userId: 'user5',
        userName: 'Leila Saidi',
        userPhotoUrl: null,
        location: 'Gafsa, Tunisia',
        latitude: 34.4268,
        longitude: 8.7839,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'Queen Size Bed Frame - Wooden',
        description:
            'Solid wooden queen size bed frame in excellent condition. Includes memory foam mattress (6 months old). Modern design.',
        category: 'Home & Furniture',
        type: ItemType.don,
        imageUrls: ['https://via.placeholder.com/300x300?text=Bed+Frame'],
        userId: 'user6',
        userName: 'Samir Khaled',
        userPhotoUrl: null,
        location: 'Bizerte, Tunisia',
        latitude: 37.2744,
        longitude: 9.8739,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'Dell Inspiron Laptop - 15 inch',
        description:
            'Dell Inspiron 15 with Intel i5, 8GB RAM, 256GB SSD. Intel HD Graphics. Great for work and everyday use. Light scratches on the back.',
        category: 'Electronics',
        type: ItemType.troc,
        imageUrls: ['https://via.placeholder.com/300x300?text=Laptop'],
        userId: 'user7',
        userName: 'Sara Williams',
        userPhotoUrl: null,
        location: 'Sfax, Tunisia',
        latitude: 34.7413,
        longitude: 10.7606,
        createdAt: now.subtract(const Duration(hours: 18)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'Wooden Office Desk - Free',
        description:
            'Sturdy wooden office desk with storage drawer. Brown oak finish. Requires assembly or can be taken apart. Perfect for home office setup.',
        category: 'Home & Furniture',
        type: ItemType.don,
        imageUrls: ['https://via.placeholder.com/300x300?text=Desk'],
        userId: 'user8',
        userName: 'Ali Mansouri',
        userPhotoUrl: null,
        location: 'Marsa Ghaleb, Tunisia',
        latitude: 35.8256,
        longitude: 10.6369,
        createdAt: now.subtract(const Duration(hours: 10)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'Samsung 42" Smart TV',
        description:
            'Samsung 42-inch Full HD Smart TV (2020 model). Works perfectly, excellent picture quality. Comes with remote and HDMI cables.',
        category: 'Electronics',
        type: ItemType.troc,
        imageUrls: ['https://via.placeholder.com/300x300?text=Samsung+TV'],
        userId: 'user9',
        userName: 'Rania Zahra',
        userPhotoUrl: null,
        location: 'Rades, Tunisia',
        latitude: 36.7500,
        longitude: 10.1833,
        createdAt: now.subtract(const Duration(hours: 14)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'Office Chair - Ergonomic',
        description:
            'Comfortable ergonomic office chair with adjustable height and armrests. Black mesh back. Perfect condition, barely used.',
        category: 'Home & Furniture',
        type: ItemType.don,
        imageUrls: ['https://via.placeholder.com/300x300?text=Office+Chair'],
        userId: 'user10',
        userName: 'Karim Ben Salah',
        userPhotoUrl: null,
        location: 'La Marsa, Tunisia',
        latitude: 36.8667,
        longitude: 10.3250,
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      ItemModel(
        id: uuid.v4(),
        title: 'Exercise Equipment Bundle',
        description:
            'Set of dumbbells (5kg-20kg), yoga mat, and resistance bands. All in good condition. Perfect for home workout setup.',
        category: 'Sports & Outdoors',
        type: ItemType.don,
        imageUrls: ['https://via.placeholder.com/300x300?text=Exercise+Gear'],
        userId: 'user11',
        userName: 'Hana Khalil',
        userPhotoUrl: null,
        location: 'Bab Bhar, Tunisia',
        latitude: 36.8000,
        longitude: 10.1667,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }

  /// Generate sample posts for demo
  static List<PostModel> generateSamplePosts() {
    final now = DateTime.now();
    return [
      PostModel(
        id: uuid.v4(),
        title: 'Tips for Sustainable Living',
        description:
            'In this post, I share my journey on how I reduced waste by 80% in my household. Simple daily habits that made a huge difference!',
        userId: 'user1',
        userName: 'Ahmed Hassan',
        userPhotoUrl: null,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      PostModel(
        id: uuid.v4(),
        title: 'Best Places to Exchange Items in Tunis',
        description:
            'A comprehensive guide to community markets and barter groups where you can exchange items instead of buying new.',
        userId: 'user2',
        userName: 'Fatima Ben',
        userPhotoUrl: null,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      PostModel(
        id: uuid.v4(),
        title: 'How to Organize a Successful Item Exchange Event',
        description:
            'Step-by-step guide to organizing a community exchange event in your neighborhood.',
        userId: 'user3',
        userName: 'Mohamed Ali',
        userPhotoUrl: null,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      PostModel(
        id: uuid.v4(),
        title: 'Why Sharing Economy Matters',
        description:
            'A deep dive into how the sharing economy is reshaping consumer habits and building stronger communities.',
        userId: 'user4',
        userName: 'Noor Jasmine',
        userPhotoUrl: null,
        createdAt: now.subtract(const Duration(hours: 20)),
      ),
      PostModel(
        id: uuid.v4(),
        title: 'My Experience Using Our Community Exchange App',
        description:
            'A honest review of using the Don & Troc app for 3 months - what I loved and what could be improved.',
        userId: 'user5',
        userName: 'Leila Saidi',
        userPhotoUrl: null,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }

  /// Generate sample chats/conversations for Messaging page
  static List<ChatModel> generateSampleChats() {
    final now = DateTime.now();
    return [
      ChatModel(
        id: uuid.v4(),
        userIds: ['current_user', 'user1'],
        itemId: uuid.v4(),
        itemTitle: 'iPhone 13 Pro - 256GB',
        lastMessage: 'Hi, is this item still available?',
        lastMessageSenderId: 'user1',
        updatedAt: now.subtract(const Duration(hours: 2)),
        unreadCount: 1,
      ),
      ChatModel(
        id: uuid.v4(),
        userIds: ['current_user', 'user2'],
        itemId: uuid.v4(),
        itemTitle: 'Wooden Office Desk - Free',
        lastMessage: 'Can we meet tomorrow afternoon?',
        lastMessageSenderId: 'user2',
        updatedAt: now.subtract(const Duration(hours: 5)),
        unreadCount: 0,
      ),
      ChatModel(
        id: uuid.v4(),
        userIds: ['current_user', 'user3'],
        itemId: uuid.v4(),
        itemTitle: 'Mountain Bike - Trek series',
        lastMessage: 'I\'m very interested! What\'s the lowest price?',
        lastMessageSenderId: 'user3',
        updatedAt: now.subtract(const Duration(hours: 8)),
        unreadCount: 0,
      ),
      ChatModel(
        id: uuid.v4(),
        userIds: ['current_user', 'user7'],
        itemId: uuid.v4(),
        itemTitle: 'Dell Inspiron Laptop - 15 inch',
        lastMessage: 'Thanks for the offer! I\'ll take it.',
        lastMessageSenderId: 'user7',
        updatedAt: now.subtract(const Duration(hours: 12)),
        unreadCount: 0,
      ),
      ChatModel(
        id: uuid.v4(),
        userIds: ['current_user', 'user8'],
        itemId: uuid.v4(),
        itemTitle: 'Samsung 42" Smart TV',
        lastMessage: 'When can you deliver it?',
        lastMessageSenderId: 'user8',
        updatedAt: now.subtract(const Duration(hours: 15)),
        unreadCount: 1,
      ),
      ChatModel(
        id: uuid.v4(),
        userIds: ['current_user', 'user9'],
        itemId: uuid.v4(),
        itemTitle: 'Books Collection - Self Development',
        lastMessage: 'Perfect! See you on Saturday at 3 PM',
        lastMessageSenderId: 'user9',
        updatedAt: now.subtract(const Duration(hours: 20)),
        unreadCount: 0,
      ),
    ];
  }
}
