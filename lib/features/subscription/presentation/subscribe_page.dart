import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/router/app_router.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../shared/domain/entities/fund.dart';
import '../../../shared/domain/entities/transaction.dart';
import '../../../shared/domain/entities/user_balance.dart';
import '../../../shared/providers/balance_provider.dart';
import '../../../shared/providers/transaction_provider.dart';
import '../../../shared/data/services/transaction_service.dart';
import '../../../features/funds/providers/fund_provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../shared/providers/selected_fund_provider.dart';

// Subscription page with fund selection and investment form
class SubscribePage extends ConsumerStatefulWidget {
  const SubscribePage({super.key});

  @override
  ConsumerState<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends ConsumerState<SubscribePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  Fund? _selectedFund;
  NotificationMethod _notificationMethod = NotificationMethod.email;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fundProvider.notifier).loadFunds();
      // Si hay un fondo seleccionado, lo asigna y limpia el provider
      final selectedFund = ref.read(selectedFundProvider);
      if (selectedFund != null) {
        setState(() {
          _selectedFund = selectedFund;
          _amountController.text = selectedFund.montoMinimo.replaceAll(
            RegExp(r'[^\d]'),
            '',
          );
        });
        ref.read(selectedFundProvider.notifier).state = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundsState = ref.watch(fundProvider);
    final balance = ref.watch(balanceProvider);

    return AppLayout(
      currentRoute: AppRoute.subscribe,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(balance),
                const SizedBox(height: 32),
                _buildSubscriptionForm(fundsState.funds),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UserBalance balance) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suscribirse a Fondo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Saldo disponible: ${ref.read(balanceProvider.notifier).formattedAvailableBalance}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionForm(List<Fund> funds) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate horizontal padding for desktop
        final horizontalPadding =
            constraints.maxWidth >= 768 ? constraints.maxWidth * 0.25 : 0.0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFundSelection(funds),
                    const SizedBox(height: 24),
                    _buildAmountInput(),
                    const SizedBox(height: 24),
                    _buildNotificationMethodSelection(),
                    const SizedBox(height: 32),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFundSelection(List<Fund> funds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seleccionar Fondo',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Fund>(
          value: _selectedFund,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Selecciona un fondo',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          items:
              funds.map((fund) {
                return DropdownMenuItem(
                  value: fund,
                  child: Text(
                    AppHelpers.formatFundName(fund.nombre),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
          onChanged: (fund) {
            setState(() {
              _selectedFund = fund;
              // Parse the string amount and set it without commas
              final cleanAmount =
                  fund?.montoMinimo.replaceAll(RegExp(r'[^\d]'), '') ?? '';
              _amountController.text = cleanAmount;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Por favor selecciona un fondo';
            }
            return null;
          },
        ),
        if (_selectedFund != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Monto mínimo: \$${_selectedFund!.montoMinimo.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monto a Invertir',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Ingresa el monto',
            prefixText: 'COP \$ ',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa un monto';
            }

            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Por favor ingresa un monto válido';
            }

            if (_selectedFund != null) {
              final minAmount =
                  double.tryParse(
                    _selectedFund!.montoMinimo.replaceAll(RegExp(r'[^\d]'), ''),
                  ) ??
                  0;
              if (amount < minAmount) {
                return 'El monto mínimo es \$${_selectedFund!.montoMinimo}';
              }
            }

            final balance = ref.read(balanceProvider);
            if (!ref.read(balanceProvider.notifier).canInvest(amount)) {
              return 'Saldo insuficiente. Disponible: ${ref.read(balanceProvider.notifier).formattedAvailableBalance}';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNotificationMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Método de Notificación',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 768) {
              // Mobile layout: vertical stack without Expanded
              return Column(
                children: [
                  RadioListTile<NotificationMethod>(
                    title: const Text('Email'),
                    value: NotificationMethod.email,
                    groupValue: _notificationMethod,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _notificationMethod = value;
                        });
                      }
                    },
                  ),
                  RadioListTile<NotificationMethod>(
                    title: const Text('SMS'),
                    value: NotificationMethod.sms,
                    groupValue: _notificationMethod,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _notificationMethod = value;
                        });
                      }
                    },
                  ),
                ],
              );
            } else {
              // Desktop layout: horizontal row with Expanded
              return Row(
                children: [
                  Expanded(
                    child: RadioListTile<NotificationMethod>(
                      title: const Text('Email'),
                      value: NotificationMethod.email,
                      groupValue: _notificationMethod,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _notificationMethod = value;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<NotificationMethod>(
                      title: const Text('SMS'),
                      value: NotificationMethod.sms,
                      groupValue: _notificationMethod,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _notificationMethod = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _resetForm,
            child: const Text('Limpiar'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitSubscription,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text('Suscribirse'),
          ),
        ),
      ],
    );
  }

  void _resetForm() {
    setState(() {
      _selectedFund = null;
      _amountController.clear();
      _notificationMethod = NotificationMethod.email;
    });
    _formKey.currentState?.reset();
  }

  Future<void> _submitSubscription() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final fund = _selectedFund!;

      // Create transaction
      final transaction = Transaction(
        id: TransactionService().generateTransactionId(),
        fundId: fund.id.toString(),
        fundName: fund.nombre,
        type: TransactionType.subscription,
        amount: amount,
        notificationMethod: _notificationMethod,
        createdAt: DateTime.now(),
      );

      // Update balance and save transaction
      await ref
          .read(balanceProvider.notifier)
          .subscribeToFund(fund.id.toString(), amount);
      await ref.read(transactionProvider.notifier).addTransaction(transaction);

      if (mounted) {
        _showSuccessDialog(fund, amount);
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(Fund fund, double amount) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder:
          (context) => AlertDialog(
            title: const Text('¡Suscripción Exitosa!'),
            content: Text(
              'Te has suscrito exitosamente al fondo ${AppHelpers.formatFundName(fund.nombre)} '
              'por un monto de COP \$${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}.\n\n'
              'Recibirás una notificación por ${_notificationMethod.name.toUpperCase()}.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog first
                  Navigator.of(context).pop();
                  // Navigate to home page using custom router
                  AppRouter.navigateToMain();
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
