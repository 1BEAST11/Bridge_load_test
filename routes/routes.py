from dotenv import load_dotenv
import os

load_dotenv()


def auth(l):
    l.client.post('/rv3/authorization/sign_in', json={
        "login": os.getenv('LOGIN'),
        "password": os.getenv('PASSWORD'),
        "deviceId": os.getenv('DEVICE_ID')
    })


def balance(l):
    l.client.get(f'/rv3/home/balance?id={os.getenv('USER_ID')}',
                 headers={"Authorization": f'Token {os.getenv('AUTH_TOKEN')}'})


def service_connect(l):
    l.client.post('/rv3/home/sender', json={
        "city": os.getenv('CITY'),
        "data": {
            "usluga": os.getenv('SERVICE'),
            "fio": os.getenv('FIO'),
            "phone": os.getenv('PHONE'),
            "address": os.getenv('ADDRESS'),
            "no_d": os.getenv('NO_D')
        }
    }, headers={"Authorization": f'Token {os.getenv('AUTH_TOKEN')}'})


def payment_details(l):
    l.client.get(
        f'/rv3/home/payment_details?id={os.getenv('USER_ID')}&from={os.getenv('PAYMENT_START')}&to={os.getenv('PAYMENT_END')}',
        headers={"Authorization": f'Token {os.getenv('AUTH_TOKEN')}'})


def tariff_info(l):
    l.client.get(
        f'/rv3/services/tariff_info?id={os.getenv('USER_ID')}',
        headers={"Authorization": f'Token {os.getenv('AUTH_TOKEN')}'})
