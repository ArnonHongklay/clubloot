import string
import random
from locust import HttpLocust, TaskSet, task

def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

class UserBehavior(TaskSet):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """

    # @task(3)
    # def index(self):
    #     self.client.get("/")

    @task(3)
    def get_all_contests(self):
        """ create contest """
        token = "58ea4924ed5f2c6c9971ac62"
        self.client.get("/v2/contests/program/" + token + "/all_contests")

    @task(2)
    def sign_in(self):
        params = { "email": "arnon@hongklay.com", "password": "12341234" }
        self.client.post("/v2/auth/sign_in", params)

    @task(1)
    def sign_up(self):
        uniq_id = id_generator()
        params = {
            "email": uniq_id + "@mail.com",
            "password": "12341234",
            "confirm_password": "12341234",
            "username": uniq_id,
            "date_of_birth": "11/11/2534",
            "promo": ""
        }
        self.client.post("/v2/auth/sign_up", params)

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 5000
    max_wait = 9000
