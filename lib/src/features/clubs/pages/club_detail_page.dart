import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/club.dart';
import '../../../models/club_member.dart';
import '../../../models/club_announcement.dart';
import '../../../models/club_award.dart';
import '../../../models/event.dart';

class ClubDetailPage extends StatefulWidget {
  final Club club;

  const ClubDetailPage({
    super.key,
    required this.club,
  });

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;

  List<ClubMember> _members = [];
  List<Event> _events = [];
  List<ClubAnnouncement> _announcements = [];
  List<ClubAward> _awards = [];

  bool _isLoadingMembers = true;
  bool _isLoadingEvents = true;
  bool _isLoadingAnnouncements = true;
  bool _isLoadingAwards = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    _loadMembers();
    _loadEvents();
    _loadAnnouncements();
    _loadAwards();
  }

  Future<void> _loadMembers() async {
    try {
      final data = await _apiService.getClubMembers(widget.club.id);
      setState(() {
        _members = data.map((json) => ClubMember.fromJson(json)).toList();
        _isLoadingMembers = false;
      });
    } catch (e) {
      setState(() => _isLoadingMembers = false);
    }
  }

  Future<void> _loadEvents() async {
    try {
      final data = await _apiService.getClubEvents(widget.club.id);
      setState(() {
        _events = data.map((json) => Event.fromJson(json)).toList();
        _isLoadingEvents = false;
      });
    } catch (e) {
      setState(() => _isLoadingEvents = false);
    }
  }

  Future<void> _loadAnnouncements() async {
    try {
      final data = await _apiService.getClubAnnouncements(widget.club.id);
      setState(() {
        _announcements = data.map((json) => ClubAnnouncement.fromJson(json)).toList();
        _isLoadingAnnouncements = false;
      });
    } catch (e) {
      setState(() => _isLoadingAnnouncements = false);
    }
  }

  Future<void> _loadAwards() async {
    try {
      final data = await _apiService.getClubAwards(widget.club.id);
      setState(() {
        _awards = data.map((json) => ClubAward.fromJson(json)).toList();
        _isLoadingAwards = false;
      });
    } catch (e) {
      setState(() => _isLoadingAwards = false);
    }
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _parseColor(widget.club.primaryColor);
    final secondaryColor = _parseColor(widget.club.secondaryColor);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.club.name),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, secondaryColor],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.club.logoUrl != null)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.network(
                              widget.club.logoUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.groups, size: 48);
                              },
                            ),
                          )
                        else
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.groups, size: 48),
                          ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (widget.club.tagline != null)
                      Text(
                        widget.club.tagline!,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (widget.club.description != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.club.description!,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          icon: Icons.people,
                          label: 'Members',
                          value: widget.club.memberCount.toString(),
                          color: primaryColor,
                        ),
                        _buildStatItem(
                          icon: Icons.event,
                          label: 'Events',
                          value: widget.club.eventCount.toString(),
                          color: primaryColor,
                        ),
                        _buildStatItem(
                          icon: Icons.emoji_events,
                          label: 'Awards',
                          value: widget.club.awardsCount.toString(),
                          color: primaryColor,
                        ),
                        _buildStatItem(
                          icon: Icons.star,
                          label: 'Rating',
                          value: widget.club.rating.toStringAsFixed(1),
                          color: primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Contact Info
                    if (widget.club.email != null ||
                        widget.club.phone != null ||
                        widget.club.website != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              if (widget.club.email != null)
                                _buildContactItem(
                                  Icons.email,
                                  widget.club.email!,
                                  primaryColor,
                                ),
                              if (widget.club.phone != null)
                                _buildContactItem(
                                  Icons.phone,
                                  widget.club.phone!,
                                  primaryColor,
                                ),
                              if (widget.club.website != null)
                                _buildContactItem(
                                  Icons.language,
                                  widget.club.website!,
                                  primaryColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: primaryColor,
                  tabs: const [
                    Tab(text: 'Members'),
                    Tab(text: 'Events'),
                    Tab(text: 'News'),
                    Tab(text: 'Awards'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMembersTab(),
            _buildEventsTab(),
            _buildAnnouncementsTab(),
            _buildAwardsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTab() {
    if (_isLoadingMembers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_members.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No members yet', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final member = _members[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _parseColor(widget.club.primaryColor),
              child: member.user?.avatarUrl != null
                  ? ClipOval(
                      child: Image.network(
                        member.user!.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            member.user?.fullName[0].toUpperCase() ?? 'M',
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    )
                  : Text(
                      member.user?.fullName[0].toUpperCase() ?? 'M',
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
            title: Text(member.user?.fullName ?? 'Member'),
            subtitle: Text(member.position ?? member.role),
            trailing: member.role == 'president' || member.role == 'admin'
                ? const Icon(Icons.star, color: Colors.amber)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildEventsTab() {
    if (_isLoadingEvents) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No events yet', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _parseColor(widget.club.primaryColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.event,
                color: _parseColor(widget.club.primaryColor),
              ),
            ),
            title: Text(event.title),
            subtitle: Text(event.formattedStartDate),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementsTab() {
    if (_isLoadingAnnouncements) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_announcements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No announcements yet', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _announcements.length,
      itemBuilder: (context, index) {
        final announcement = _announcements[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (announcement.isPinned)
                      const Icon(Icons.push_pin, size: 16, color: Colors.amber),
                    if (announcement.isPinned) const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildPriorityBadge(announcement.priority),
                  ],
                ),
                const SizedBox(height: 8),
                Text(announcement.content),
                const SizedBox(height: 8),
                Text(
                  announcement.formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'urgent':
        color = Colors.red;
        break;
      case 'high':
        color = Colors.orange;
        break;
      case 'normal':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAwardsTab() {
    if (_isLoadingAwards) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_awards.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No awards yet', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _awards.length,
      itemBuilder: (context, index) {
        final award = _awards[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
            title: Text(award.awardName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (award.eventName != null) Text(award.eventName!),
                if (award.position != null)
                  Text(
                    award.position!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (award.prizeAmount != null) Text(award.formattedPrize),
                if (award.awardedDate != null) Text(award.formattedDate),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
