#!/usr/bin/env python3
# Update!! colorful text implemented, user experience enhanced. Read the changelog for more details
# This programme was built by Demiz, Eddie, Emmanuel Kweh
# This programme allows users to create multiple Wallets for business purposes using a single account
# Name of programme, Quick Transfer
from bullet import Input, Password
from firstproj import User_Account_Handler as U
from pandas import DataFrame, read_csv
from random import randrange as ran
from pyttsx3 import init, speak
from multiprocessing import Process
from art import tprint


obj = init()
voice = obj.getProperty("voices")
obj.setProperty("voice", voice[12].id)
obj.runAndWait()
speech = input("\033[1;97;10menter 'y' to activate speech or 'n' not to: \033[1;96;10m") or "y"
if speech == "y": speak("Speech activated")
def speech_output(s, end="\n"):
    print(s, end=end)
    if speech == "y":
        speak(s.replace("!", ""))


class Wallet(object):
    def __init__(self, pin="", cpin="", username="user"+"".join([str(ran(1, 10)) for i in range(5)]), locate="/home/demiz/Desktop/quick_transfer.csv"):
        self._pin = pin
        self._cpin = cpin
        self.locate = locate
        self.username = username
        self.id = "QT-" + "".join([str(ran(1, 10)) for i in range(13)])

    def accout_creation(self):
        try:
            file = read_csv(self.locate)
        except:
            file = DataFrame(columns=["Wallet_name", "Wallet_ID", "Amount", "User_PIN"])
        if self._pin != self._cpin:
            speech_output("PIN doesn't match")
            return
        if len(self._pin) != 5:
            speech_output("PIN must be five digits")
            return
        if self.id not in file["Wallet_ID"]:
            file1 = DataFrame({"Wallet_name": [self.username],
                               "Wallet_ID": [self.id],
                               "Amount": [0],
                               "User_PIN": [self._pin]})
            file = file.append(file1, ignore_index=True)
            file = file[["Wallet_ID", "Wallet_name", "Amount", "User_PIN"]]
        else:
            return Wallet(self.username, self.locate).accout_creation()
        file.to_csv(self.locate)

    def update_message(self):
        if self._pin == self._cpin and len(self._cpin) == 5:
            speech_output(f"Wallet setup successfully, this is your wallet ID: ", "")
            print(f"\033[3;93;10m{self.id}")
        else:
            speech_output(f"Wallet setup failed")

def deposit(sender_id, wallet_id, amount, pin):
    path = Wallet().locate
    a_changes = read_csv(path)
    if not sender_id in list(a_changes["Wallet_ID"]):
        speech_output("Invalid sender ID")
        return
    elif not wallet_id in list(a_changes["Wallet_ID"]):
        speech_output("Invalid receiver ID")
        return
    a_changes.set_index("Wallet_ID", inplace=True)
    if str(a_changes.loc[sender_id, "User_PIN"]) != pin:
        speech_output("Invalid Credentials!")
        return
    if sender_id != wallet_id:
        if a_changes.loc[sender_id, "Amount"] < float(amount):
            speech_output("Insufficient Balance!!")
            return
        a_changes.loc[sender_id, "Amount"] -= float(amount)
    a_changes.loc[wallet_id, "Amount"] += float(amount)
    a_changes.to_csv(path)
    speech_output("Successful Deposit!!")


def withdraw(wallet_id, amount, pin):
    path = Wallet().locate
    a_change = read_csv(path)
    if not wallet_id in list(a_change["Wallet_ID"]):
        speech_output("Invalid ID")
        return
    a_change.set_index("Wallet_ID", inplace=True)
    if a_change.loc[wallet_id, "Amount"] < float(amount):
        speech_output("Error!, Insufficient funds")
        return
    if str(a_change.loc[wallet_id, "User_PIN"]) != pin:
        speech_output("Invalid Credentials!")
        return
    a_change.loc[wallet_id, "Amount"] -= float(amount)
    a_change.to_csv(path)
    speech_output("Withdraw Successful!!")


def check_balance(wallet_id, pin):
    path = Wallet().locate
    check = read_csv(path)
    if not wallet_id in list(check["Wallet_ID"]):
        speech_output("Invalid ID")
        return
    check.set_index("Wallet_ID", inplace=True)
    if str(check.loc[wallet_id, "User_PIN"]) != pin:
        speech_output("Invalid Credentials")
        return
    speech_output(f"Total Balance: {check.loc[wallet_id, 'Amount']}\n")


def not_repeat():
    while True:
        print("      \033[0;0;0m___________________________________\n"
              "      | 1.", "\033[1;97;10mDeposit", "\033[0;0;0m                     |\n"
              "      | 2.", "\033[1;97;10mWithdraw", "\033[0;0;0m                    |\n"
              "      | 3.", "\033[1;97;10mCheck Balance", "\033[0;0;0m               |\n"
              "      | 0.", "\033[1;97;10mQuit", "\033[0;0;0m                        |\n"
              "      -----------------------------------\n"
              )
        opt1 = input("\033[3;97;10m>>> \033[1;96;10m")
        print("\033[0;0;0m")
        if opt1 == "1":
            deposit(
                input("\033[1;97;10menter sender's ID: \033[1;96;10m"),
                input("\033[1;97;10menter receiver's ID: \033[1;96;10m"),
                input("\033[1;97;10menter amount to deposit: \033[1;96;10m"),
                input("\033[1;97;10menter PIN: \033[1;96;10m")
            )
        elif opt1 == "2":
            withdraw(
                input("\033[1;97;10mEnter ID: \033[1;96;10m"),
                input("\033[1;97;10mEnter amount: \033[1;96;10m"),
                input("\033[1;97;10mEnter PIN: \033[1;96;10m")
            )
        elif opt1 == "3":
            check_balance(
                input("\033[1;97;10menter wallet id: \033[1;96;10m"),
                input("\033[1;97;10menter PIN: \033[1;96;10m")
            )
        elif opt1 == "0":
            speech_output("Exiting programme...")
            break
        else: pass
        print("\033[0;0;0m")



def options():
    print("      ___________________________________\n"
          "      | 1.", "\033[1;97;10mSign Up", "\033[0;0;0m                      |\n"
          "      | 2.", "\033[1;97;10mLogin", "\033[0;0;0m                        |\n"
          "      | 0.", "\033[1;97;10mQuit", "\033[0;0;0m                         |\n"
          "      -----------------------------------\n"
          )
    op1 = input("\033[3;97;10m>>> \033[1;96;10m")
    print("\033[0;0;0m")
    if op1 == "1":
        s = U().sign_up(); speech_output(s); print("\n")
        if s == "Account Successfully created!!":
            x = Wallet(input("\033[1;97;10mCreate user PIN (5 digits): \033[1;96;10m"),
                       input("\033[1;97;10mConfirm PIN: \033[1;96;10m"),
                       input("\033[1;97;10mEnter the name of this Wallet: \033[1;96;10m"))
            x.accout_creation()
            x.update_message()
            not_repeat()
        else: options()
    elif op1 == "2":
        s = U().login(); speech_output(s); print("\n")
        if s == "Login Successfully!!": not_repeat()
        else: options()
    elif op1 == "0":
        speech_output("Exiting programme...")
    else: options()


if __name__ == "__main__":
    print("\033[5;93;10m")
    tprint("Quick Transfer", "georgia11")
    print("\033[0;0;0m")
    options()
