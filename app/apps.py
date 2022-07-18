from django.apps import AppConfig


class AppConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'app'

    def ready(self):
        from polaris.integrations import register_integrations
        from app.integrations import (
            MyDepositIntegration,
            MyWithdrawalIntegration,
            MyCustomerIntegration,
            MySEP31ReceiverIntegration,
            MyRailsIntegration,
            MyQuoteIntegration,
            fee_integration,
            info_integration,
        )

        register_integrations(
            deposit=MyDepositIntegration(),
            withdrawal=MyWithdrawalIntegration(),
            fee=fee_integration,
            sep6_info=info_integration,
            customer=MyCustomerIntegration(),
            sep31_receiver=MySEP31ReceiverIntegration(),
            rails=MyRailsIntegration(),
            quote=MyQuoteIntegration(),
        )