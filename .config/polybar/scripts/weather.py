#!/bin/python
# -*- coding: utf-8 -*-

# Procedure
# Surf to https://openweathermap.org/city
# Fill in your CITY
# e.g. Antwerp Belgium
# Check url
# https://openweathermap.org/city/2803138
# you will the city code at the end
# create an account on this website
# create an api key (free)
# LANG included thanks to krive001 on discord


import requests

CITY = "2262544"
API_KEY = "b0db9d3e3017bb311c96a8aca1ba2851"
UNITS = "Metric"
UNIT_KEY = "C"
#UNIT_KEY = "F"
LANG = "en"
#LANG = "nl"
#LANG = "hu"

REQ = requests.get("http://api.openweathermap.org/data/2.5/weather?id={}&lang={}&appid={}&units={}".format(CITY, LANG,  API_KEY, UNITS))
try:
    # HTTP CODE = OK
    if REQ.status_code == 200:
        ICON = REQ.json()["weather"][0]["icon"]
        NAME = REQ.json()["name"]
        CURRENT = REQ.json()["weather"][0]["description"].capitalize()
        TEMP = int(float(REQ.json()["main"]["temp"]))
        print("{}: {}, {} °{}".format(NAME, CURRENT, TEMP, UNIT_KEY))
    else:
        print("Error: BAD HTTP STATUS CODE " + str(REQ.status_code))
except (ValueError, IOError):
    print("Error: Unable print the data")
