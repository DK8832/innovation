import logging
import os
import smtplib
from email.mime.text import MIMEText

logger = logging.getLogger("mailer")


def _smtp_config():
    host = os.environ.get("SMTP_HOST")
    user = os.environ.get("SMTP_USER")
    password = os.environ.get("SMTP_PASS")
    port = int(os.environ.get("SMTP_PORT", "587"))
    if not (host and user and password):
        return None
    return {"host": host, "port": port, "user": user, "password": password}


def send_email(to: str, subject: str, body: str) -> bool:
    """실제로 메일을 보낸다. SMTP가 설정되어 있지 않으면 발송 성공을 흉내내지 않고
    로그만 남긴 뒤 False를 돌려준다 (거짓 성공 응답 금지)."""
    config = _smtp_config()
    if config is None:
        logger.warning(
            "SMTP 미설정(SMTP_HOST/SMTP_USER/SMTP_PASS 환경변수 없음) — '%s' 메일 발송 생략: %s",
            to,
            subject,
        )
        return False

    msg = MIMEText(body, _charset="utf-8")
    msg["Subject"] = subject
    msg["From"] = config["user"]
    msg["To"] = to

    try:
        with smtplib.SMTP(config["host"], config["port"], timeout=10) as server:
            server.starttls()
            server.login(config["user"], config["password"])
            server.sendmail(config["user"], [to], msg.as_string())
        logger.info("메일 발송 성공: %s -> %s", subject, to)
        return True
    except Exception as exc:
        logger.error("메일 발송 실패: %s -> %s (%s)", subject, to, exc)
        return False
