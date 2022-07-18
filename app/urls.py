from django.urls import path
from .views import all_fields_form_view, confirm_email, skip_confirm_email, log_callback

urlpatterns = [
    path("all-fields", all_fields_form_view),
    path("confirm_email", confirm_email, name="confirm_email"),
    path("skip_confirm_email", skip_confirm_email, name="skip_confirm_email"),
    path("onChangeCallback", log_callback),
]
