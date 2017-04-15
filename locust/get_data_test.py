from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """

    # @task(3)
    # def join_contest(self):
    #   """ join contest """

    # @task(2)
    # def create_contest(self):
    #   """ create contest """

    @task(2)
    def get_all_contests(self):
        """ create contest """
        token = "token"
        self.client.get("/v2/contests/programs/" + token + "all_contests")

    @task(1)
    def programs(self):
        """ sign in """
        self.client.get("/v2/contests/programs")

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 5000
    max_wait = 9000
