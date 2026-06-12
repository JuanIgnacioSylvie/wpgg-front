import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../../../features/missions/presentation/bloc/missions_bloc.dart';
import '../../../features/missions/presentation/widgets/pick_missions_dialog.dart';
import '../../../features/riot/domain/entities/summoner_entity.dart';
import '../../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../../features/riot/presentation/bloc/riot_event.dart';
import '../../../features/riot/presentation/bloc/riot_state.dart';
import '../../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../../features/notifications/presentation/bloc/notifications_inbox_bloc.dart';
import '../../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../firebase/firebase_bootstrap.dart';
import '../../l10n/l10n_extension.dart';
import 'web_document_title.dart';
import 'web_dot_grid_background.dart';
import 'web_notifications_panel.dart';
import 'web_profile_dialog.dart';
import 'web_shell_scope.dart';
import 'web_shell_transition.dart';
import 'web_sidebar.dart';
import 'web_motion.dart';
import 'web_top_bar.dart';

class WebAppShellPage extends StatefulWidget {
  const WebAppShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<WebAppShellPage> createState() => _WebAppShellPageState();
}

class _WebAppShellPageState extends State<WebAppShellPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  var _sidebarExpanded = false;
  var _profileDialogOpen = false;
  var _notificationsPanelOpen = false;

  final _notificationsBellKey = GlobalKey();
  OverlayEntry? _notificationsOverlay;
  late final AnimationController _notificationsAnim;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationsAnim = AnimationController(
      vsync: this,
      duration: WebMotion.normal,
    );
    context.read<RiotBloc>().add(const LoadDashboard());
    context.read<DDragonProvider>().ensureLoaded();
    context.read<MissionsBloc>().add(const LoadMissionsHome());
    context.read<WalletBloc>().add(const LoadWallet());
    context.read<NotificationsInboxBloc>().add(const LoadNotificationsInbox());
    context.read<NotificationsBloc>().add(const ResumeWebPushRegistration());

    setWebPushForegroundListener(() {
      if (!mounted) return;
      context.read<NotificationsInboxBloc>().add(
            const RefreshNotificationsInbox(),
          );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final location = GoRouterState.of(context).uri.path;
      if (location.startsWith('/profile')) {
        _openProfileDialog();
        if (widget.navigationShell.currentIndex == 4) {
          widget.navigationShell.goBranch(0, initialLocation: true);
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationsOverlay?.remove();
    _notificationsOverlay = null;
    _notificationsAnim.dispose();
    setWebPushForegroundListener(null);
    resetWebDocumentTitle();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !mounted) {
      return;
    }
    context.read<NotificationsInboxBloc>().add(
          const RefreshNotificationsInbox(),
        );
    context.read<NotificationsBloc>().add(const ResumeWebPushRegistration());
  }

  void _openPickMissions() {
    showPickMissionsDialog(context);
  }

  void _onSidebarTap(int branchIndex) {
    setState(() => _profileDialogOpen = false);
    widget.navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == widget.navigationShell.currentIndex,
    );
    if (branchIndex == 0) {
      context.read<MissionsBloc>().add(const LoadMissionsHome());
    }
  }

  Future<void> _openProfileDialog() async {
    if (_profileDialogOpen) return;
    setState(() => _profileDialogOpen = true);
    await showWebProfileDialog(context);
    if (mounted) {
      setState(() => _profileDialogOpen = false);
    }
  }

  Future<void> _logout() async {
    _closeNotificationsPanel();
    await context.read<NotificationsBloc>().unregisterPushToken();
    if (!mounted) return;
    context.read<AuthBloc>().add(const LogoutRequested());
  }

  void _toggleNotificationsPanel() {
    if (_notificationsPanelOpen) {
      _closeNotificationsPanel();
      return;
    }
    if (_profileDialogOpen) {
      Navigator.of(context, rootNavigator: true).maybePop();
    }
    context.read<NotificationsInboxBloc>().add(
          const RefreshNotificationsInbox(),
        );
    _openNotificationsPanel();
  }

  void _openNotificationsPanel() {
    final anchorRect = notificationsPanelAnchorRect(_notificationsBellKey);
    if (anchorRect == null) return;

    final bloc = context.read<NotificationsInboxBloc>();
    _notificationsAnim.value = 0;
    _notificationsOverlay = OverlayEntry(
      builder: (overlayContext) => WebNotificationsPanelLayer(
        animation: _notificationsAnim,
        anchorRect: anchorRect,
        bloc: bloc,
        onClose: _closeNotificationsPanel,
      ),
    );
    Overlay.of(context).insert(_notificationsOverlay!);
    setState(() => _notificationsPanelOpen = true);
    _notificationsAnim.forward();
  }

  void _closeNotificationsPanel() {
    if (!_notificationsPanelOpen) return;
    _notificationsAnim.reverse().then((_) {
      _notificationsOverlay?.remove();
      _notificationsOverlay = null;
      if (mounted) {
        setState(() => _notificationsPanelOpen = false);
      }
    });
  }

  int? _walletBalance(WalletState state) {
    return switch (state) {
      WalletLoaded(:final summary) => summary.balance,
      WalletWithdrawing(:final summary) => summary.balance,
      WalletWithdrawSuccess(:final summary) => summary.balance,
      WalletWithdrawError(:final summary) => summary.balance,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final sidebarIndex = webSidebarIndexForLocation(location);
    final sectionTitle =
        webSectionTitleForLocation(context.l10n, location);
    final isDashboard = sidebarIndex == 0;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (_, curr) => curr is AuthUnauthenticated,
          listener: (context, _) {
            resetWebDocumentTitle();
            context.go('/login');
          },
        ),
        BlocListener<NotificationsInboxBloc, NotificationsInboxState>(
          listenWhen: (prev, curr) =>
              prev is NotificationsInboxLoaded &&
                  curr is NotificationsInboxLoaded
              ? prev.unreadCount != curr.unreadCount
              : curr is NotificationsInboxLoaded,
          listener: (context, state) {
            final count =
                state is NotificationsInboxLoaded ? state.unreadCount : 0;
            updateWebDocumentTitle(unreadCount: count);
          },
        ),
      ],
      child: WebShellScope(
        onAddMission: _openPickMissions,
        child: BlocBuilder<RiotBloc, RiotState>(
          builder: (context, riotState) {
            SummonerEntity? summoner;
            if (riotState is RiotLoaded) {
              summoner = riotState.summoner;
            }

            final ddragon = context.watch<DDragonProvider>();

            return Scaffold(
              backgroundColor: Colors.black,
              body: Row(
                children: [
                  BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, walletState) {
                      return BlocBuilder<NotificationsInboxBloc,
                          NotificationsInboxState>(
                        buildWhen: (prev, curr) =>
                            prev is NotificationsInboxLoaded &&
                                curr is NotificationsInboxLoaded
                            ? prev.unreadCount != curr.unreadCount
                            : curr is NotificationsInboxLoaded ||
                                curr is NotificationsInboxLoading,
                        builder: (context, inboxState) {
                          final unreadCount = inboxState
                                  is NotificationsInboxLoaded
                              ? inboxState.unreadCount
                              : 0;

                          return WebSidebar(
                            expanded: _sidebarExpanded,
                            onToggleExpanded: () => setState(
                              () => _sidebarExpanded = !_sidebarExpanded,
                            ),
                            currentIndex: sidebarIndex,
                            onTap: _onSidebarTap,
                            onProfileTap: _openProfileDialog,
                            profileSelected: _profileDialogOpen,
                            summoner: summoner,
                            ddragon: ddragon,
                            balance: _walletBalance(walletState),
                            onLogout: _logout,
                            onNotificationsTap: _toggleNotificationsPanel,
                            notificationsBellKey: _notificationsBellKey,
                            unreadCount: unreadCount,
                            notificationsPanelOpen: _notificationsPanelOpen,
                          );
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        BlocBuilder<MissionsBloc, MissionsState>(
                          buildWhen: (prev, curr) =>
                              prev.home?.endsInSeconds !=
                                  curr.home?.endsInSeconds ||
                              prev.home != curr.home,
                          builder: (context, missionsState) {
                            final home = missionsState.home;
                            final endsIn =
                                isDashboard ? home?.endsInSeconds : null;
                            final activeCount = home == null
                                ? 0
                                : (home.primary != null ? 1 : 0) +
                                    home.secondary.length;

                            return WebTopBar(
                              sectionTitle: sectionTitle,
                              showAddButton: isDashboard,
                              addButtonEnabled: activeCount < 3,
                              showDayCountdown: isDashboard &&
                                  endsIn != null &&
                                  endsIn > 0,
                              dayEndsInSeconds: endsIn,
                              onAddTap: _openPickMissions,
                            );
                          },
                        ),
                        Expanded(
                          child: WebDotGridBackground(
                            child: WebShellBranchTransition(
                              navigationShell: widget.navigationShell,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
