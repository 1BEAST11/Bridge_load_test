from locust import TaskSet, task, tag
import routes


@tag ('random_user')
class UserBehavior(TaskSet):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.environment_data = {}

    @task(2)
    def test_auth(self):
        routes.auth(self)

    @task(3)
    def test_balance(self):
        routes.balance(self)

    @task(1)
    def test_service_connect(self):
        routes.service_connect(self)

    @task(3)
    def test_payment_details(self):
        routes.payment_details(self)

    @task(1)
    def test_tariff_info(self):
        routes.tariff_info(self)
