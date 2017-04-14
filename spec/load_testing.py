import string
import random
from locust import HttpLocust, TaskSet, task

def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

class UserBehavior(TaskSet):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """

    def sign_in(self):
        self.client.post("/v2/auth/sign_in", { "email": "a@a.com", "password": "12341234" })

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

    # @task(2)
    # def index(self):
    #     self.client.get("/")

    @task(1)
    def profile(self):
        self.sign_up()
        # self.sign_in()
        # self.client.get("/")

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 5000
    max_wait = 9000
