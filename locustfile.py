# from locust import HttpUser, task, between
# import random

# class MatchifyUser(HttpUser):
#     wait_time = between(1, 3)

#     def on_start(self):
#         response = self.client.post("/api/login", json={
#             "username": "testuser",
#             "password": "password123"
#         })
#         self.token = response.json().get("token")
#         self.headers = {"Authorization": f"Bearer {self.token}"}

    # @task(2)
    # def upload_video(self):
    #     files = {
    #         "video": ("test.mp4", open("storage/app/public/video_ai/uploads/job_1/original.mp4", "rb"), "video/mp4")
    #     }
    #     data = {"summary_type": "cards"}
    #     self.client.post("/api/videos", headers=self.headers, files=files, data=data)

    # @task(3)
    # def generate_summary(self):
    #     video_id = random.randint(1, 5)
    #     self.client.post("/api/video_summaries/generate", headers=self.headers, json={
    #         "video_id": video_id,
    #         "clips_dir": f"storage/app/public/video_ai/clips/job_{video_id}"
    #     })
from locust import HttpUser, task, between
import os

class MatchifyUser(HttpUser):
    # ⏱️ محاكاة مستخدم حقيقي
    wait_time = between(1, 3)

    def on_start(self):
        # ====================================================
        # 🔐 (1) Bearer Token (Sanctum)
        # ====================================================
        self.token = "4|HuIUGZ9d7vefYyPocDwK5MEttO8ekEotoOCJWdAy9c385777"

        self.headers = {
            "Authorization": f"Bearer {self.token}"
        }

        # ====================================================
        # 🎥 (2) مسار الفيديو
        # ====================================================
        self.video_path = (
            "C:/Users/LOQ/Desktop/Matchify Laravel/"
            "storage/app/public/video_ai/uploads/job_4/original.mp4"
        )

        if not os.path.exists(self.video_path):
            raise Exception("❌ ملف الفيديو غير موجود")

    @task
    def upload_video(self):
        with open(self.video_path, "rb") as video:
            files = {
                "video": ("test_video.mp4", video, "video/mp4")
            }

            data = {
                "summary_type": "goals"
            }

            with self.client.post(
                "/api/videos",
                headers=self.headers,
                files=files,
                data=data,
                name="Upload Video",
                catch_response=True
            ) as response:

                if response.status_code != 200:
                    response.failure(
                        f"❌ Failed ({response.status_code})"
                    )
                else:
                    response.success()
