from locust import HttpUser
import tests

class User(HttpUser):
    max_wait = 10000
    tasks = [tests.UserBehavior]