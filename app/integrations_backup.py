from typing import List
from polaris.integrations import RailsIntegration
from polaris.models import Transaction, Asset
from django.db.models import QuerySet


def toml_int(*args):
    return {
        "DOCUMENTATION": {
            "ORG_NAME": "Alfred Pay",
            "ORG_URL": "https://alfredpay.io"
        },
        "PRINCIPALS": [
            {
                "name": "Diego Yanez"
            }
        ],
        "CURRENCIES": [
            {
                'code': asset.code,
                'issuer': asset.issuer,
                'status': 'test',
                'display_decimals': 2,
                'name': 'Test Stellar Token',
                'desc': 'A fake asset on testnet for demonstration purposes.'
            } for asset in Asset.objects.all()
        ]
    }


class MyRailsIntegration(RailsIntegration):
    def poll_pending_deposits(self, pending_deposits: QuerySet) -> List[Transaction]:
        return list(pending_deposits)

    def execute_outgoing_transaction(self, transaction: Transaction):
        transaction.amount_fee = 0
        transaction.status = Transaction.STATUS.completed
        transaction.save()
