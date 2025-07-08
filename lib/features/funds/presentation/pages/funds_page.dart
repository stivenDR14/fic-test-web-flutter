import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../config/router/app_router.dart';
import '../../providers/fund_provider.dart';
import '../../../../shared/domain/entities/fund.dart';
import '../widgets/funds_cards.dart';

class FundsPage extends ConsumerStatefulWidget {
  const FundsPage({super.key});

  @override
  ConsumerState<FundsPage> createState() => _FundsPageState();
}

class _FundsPageState extends ConsumerState<FundsPage> {
  @override
  void initState() {
    super.initState();
    // Load funds when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fundProvider.notifier).loadFunds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(currentRoute: AppRoute.main, child: _buildContent());
  }

  Widget _buildContent() {
    final fundsState = ref.watch(fundProvider);

    return Padding(
      padding: const EdgeInsets.all(AppTheme.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 24),

          // Content based on state
          Expanded(
            child:
                fundsState.isLoading
                    ? _buildLoadingState()
                    : fundsState.isError
                    ? _buildErrorState(fundsState.errorMessage)
                    : _buildFundsList(fundsState.funds),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fondos de Inversión',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Explora nuestros fondos disponibles',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando fondos...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Error al cargar los fondos',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 8),
          if (errorMessage != null)
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.read(fundProvider.notifier).loadFunds(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFundsList(List<Fund> funds) {
    if (funds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_balance,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay fondos disponibles',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: funds.length,
      separatorBuilder:
          (context, index) => const SizedBox(height: AppTheme.itemSpacing),
      itemBuilder: (context, index) => buildFundCard(funds[index]),
    );
  }
}
