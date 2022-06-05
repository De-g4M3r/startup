from bullet import Password, Input
from re import search
import random as ran


class Database:
    def __init__(self, file="/home/demiz/Desktop/Projects/", file_name="Quiz_Database.txt"):
        self.file = file
        self.file_name = file_name

    def database_creation(self):
        with open(self.file + self.file_name, "+w") as d_file:
            if len(d_file.readlines()) < 1:
                d_file.write("----DataBase Created----" + "\n")


class User_Account_Handler(object):
    def __init__(self, username=Input(prompt="username: "), password=Password(prompt="password: ", hidden="*"),
                 password_2=Password(prompt="confirm password: ", hidden="*")):
        self._username = username
        self.__password = password
        self.__password_2 = password_2

    def sign_up(self):
        name = self._username.launch()
        if search(r"[^\w]+", name): return "Username cannot bare a symbol or space(s)"
        pass1 = self.__password.launch()
        if len(pass1) < 7: return "Password length too short"
        pass2 = self.__password_2.launch()
        if pass1 != pass2:
            return "Password doesn't match"
        else:
            with open(Database().file + Database().file_name, "+a") as file:
                read = open(Database().file + Database().file_name, "r")
                for i in read.readlines():
                    if i.split("|")[0] == name: return "Username already exist"
                read.close()
                file.write(f"{name}|{pass1}" + "\n")
            return "Account Successfully created!!"

    def login(self):
        name = self._username.launch()
        pass1 = self.__password.launch()
        with open(Database().file + Database().file_name, "r") as file:
            for i in file.readlines():
                if "|" in i and i.split("|")[0] == name and i.split("|")[1][:-1] == pass1:
                    return "Login Successfully!!"
        return "Invalid Credentials"


class Questions_Base(object):
    def __init__(self, levels="level_1"):
        self.levels = levels

    def level_1(self):
        return ran.randrange(0, 10), ran.randrange(0, 6)

    def level_2(self):
        return ran.randrange(0, 10), ran.randrange(0, 10)

    def level_3(self):
        level3x = ran.randrange(5, 11)
        level3y = ran.randrange(0, 10)
        level3_list = [level3x, level3y]
        level3_randompos = ran.choice(level3_list)
        level3_list.remove(level3_randompos)
        return level3_randompos, *level3_list

    def level_4(self):
        level4x = ran.randrange(7, 13)
        level4y = ran.randrange(0, 13)
        level4_list = [level4x, level4y]
        level4_randompos = ran.choice(level4_list)
        level4_list.remove(level4_randompos)
        return level4_randompos, *level4_list

    def level_5(self):
        level5x = ran.randrange(7, 13)
        level5y = ran.randrange(0, 18)
        level5_list = [level5x, level5y]
        level5_randompos = ran.choice(level5_list)
        level5_list.remove(level5_randompos)
        return level5_randompos, *level5_list

    def level_6(self):
        if ran.choice([2, 3]) == 2:
            level6x = ran.randrange(7, 16)
            level6y = ran.randrange(10, 101)
            level6_list = [level6x, level6y]
            level6_randompos = ran.choice(level6_list)
            level6_list.remove(level6_randompos)
            return level6_randompos, *level6_list
        combined_lv6 = list(Questions_Base().level_5() + (ran.randrange(10, 101, ran.choice([1, 2, 3, 4, 5, 10])),))
        combined_randompos = ran.choice(combined_lv6)
        combined_lv6.remove(combined_randompos)
        return combined_randompos, *combined_lv6

    def level_7(self):
        if ran.choice([2, 3, 4]) == 2:
            level7x = ran.randrange(7, 21)
            level7y = ran.randrange(10, 101)
            level7_list = [level7x, level7y]
            level7_randompos = ran.choice(level7_list)
            level7_list.remove(level7_randompos)
            return level7_randompos, *level7_list
        combined_lv7 = list(Questions_Base().level_5() + (ran.randrange(10, 101, ran.choice(list(range(1, 11)))),))
        combined_randompos = ran.choice(combined_lv7)
        combined_lv7.remove(combined_randompos)
        return combined_randompos, *combined_lv7

    def level_8(self):
        if ran.choice([2, 3, 4]) == 2:
            level8x = ran.randrange(7, 21)
            level8y = ran.randrange(10, 101)
            level8_list = [level8x, level8y]
            level8_randompos = ran.choice(level8_list)
            level8_list.remove(level8_randompos)
            return level8_randompos, *level8_list
        combined_lv8 = list(Questions_Base().level_5() + (ran.randrange(10, 101, ran.choice(list(range(1, 11)))),))
        combined_randompos = ran.choice(combined_lv8)
        combined_lv8.remove(combined_randompos)
        return combined_randompos, *combined_lv8


class Computation(Questions_Base):
    def __init__(self, quiz_type):
        self.quiz_type = quiz_type
        Questions_Base.__init__(self, levels="level_1")

    levels_list = [
        Questions_Base().level_1,
        Questions_Base().level_2,
        Questions_Base().level_3,
        Questions_Base().level_4,
        Questions_Base().level_5,
        Questions_Base().level_6,
        Questions_Base().level_7,
        Questions_Base().level_8
    ]

    def addition(self):
        global level_add
        for level_add in Computation.levels_list:
            if level_add.__name__ == self.quiz_type:
                break
        return level_add()

    def subtraction(self):
        global level_sub
        for level_sub in Computation.levels_list:
            if level_sub.__name__ == self.quiz_type:
                break
        return level_sub()

    def multiplication(self):
        global level_mul
        for level_mul in Computation.levels_list:
            if level_mul.__name__ == self.quiz_type:
                break
        return level_mul()


levels_dict = {
    "1": "level_1",
    "2": "level_2",
    "3": "level_3",
    "4": "level_4",
    "5": "level_5",
    "6": "level_6",
    "7": "level_7",
    "8": "level_8",
}
category_dict = {
    "1": "Addition",
    "2": "Subtraction",
    "3": "Multiplication"
}
y = "Invalid Option"

def correct_answer(tup, operation="multiplication"):
    if operation == "addition":
        return sum(tup)
    elif operation == "subtraction":
        difference = ""
        for i in tup:
            difference += str(i)
            difference += "-"
        return eval(difference[:-1])
    else:
        product = 1
        for i in tup: product *= i
        return product

class Answer_options:
    def __init__(self, answer, question):
        self.answer = answer
        self.question = question
        self.r = []
    def add(self):
        percentage = int((35 * self.answer) // 100)
        self.r = range(self.answer - percentage, percentage + self.answer + 1)
        return list(self.r)
    def options(self, ops_type, difficulty):
        def difficulty_algorithm(ans, ls):
            l = []
            for i in ls:
                if str(i)[-1] == str(ans)[-1]:
                    l.append(i)
            return l
        def shuffled(op1, op2, op3):
            shuffled_options = [op1, op2, op3]
            ran.shuffle(shuffled_options)
            return f"A. {shuffled_options[0]}\nB. {shuffled_options[1]}\nC. {shuffled_options[2]}"
        if ops_type == "addition":
            option1 = self.answer
            max_value = max(self.question)
            y = list(self.r)
            y.remove(option1)
            if max_value in y:
                option2 = ran.choice(y[y.index(max_value): ])
            else:
                option2 = ran.choice(y)
            y.remove(option2)
            if difficulty == "high" and difficulty_algorithm(option1, y) != [] and ran.choice([0, 1, 2]) == 0:
                option3 = ran.choice(difficulty_algorithm(option1, y))
            else:
                option3 = ran.choice(y)
            return shuffled(option1, option2, option3)

#for i in range(10):
 #   z = Computation("level_8").addition()
  #  print(">>", z)
   # correct_answer(z, "addition")
    #a = Answer_options(correct_answer(z, "addition"), z)
    #a.add()
    #print(a.options("addition", "high"))
    #print()

def options_mechanism():
    global option
    while True:
        print("\n"
              "==============================>>\n"
              "| Select a Category:\n"
              "| ---------------------------->>\n"
              "| 1. Addition\n"
              "| 2. Subtraction \n"
              "| 3. Multiplication\n"
              "| 4. back\n"
              "| 5. exit programme\n"
              "==============================>>\n")
        option2 = input(">> ")
        if option2 == "1" or option2 == "2" or option2 == "3":
            while True:
                print("\n"
                      "==============================>>\n"
                      "| 1. Continue progress \n"
                      "| 2. Select a level \n"
                      "| 3. back \n"
                      "| 4. exit programme\n"
                      "=============================>>\n")
                option3 = input(">> ")
                if option3 == "1":
                    print("Coming Soon...")
                    break
                elif option3 == "2":
                    print("\n"
                          "==============================>>\n"
                          "| Select a level (1 - 8) \n"
                          "| 0. Home \n"
                          "==============================>>\n")
                    option4 = input(">> ")
                    if option4 == "0":
                        break
                    try:
                        if float(option4) > 8 or float(option4) < 0:
                            print(y)
                            break
                    except ValueError:
                        print("Seriously, what are you doing?")
                        break
                    print("You have been given 10 questions, do your best.\n")
                    for i in range(10):
                        print(f"Question {i + 1}:", end="  ")
                        instant = Computation(levels_dict[option4])
                        if option2 == "1":
                            print(*instant.addition(), sep=" + ", end=" ?\n")
                            z = correct_answer(instant.addition(), "addition")
                            a = Answer_options(z, instant.addition())
                            a.add()
                            print(a.options("addition", "high"))
                            input("\n>> ")
                        elif option2 == "2":
                            print(*instant.subtraction(), sep=" - ", end=" ?")
                            input("\n>> ")
                        elif option2 == "3":
                            print(*instant.multiplication(), sep=" x ", end=" ?")
                            input("\n>> ")
                        print()
                elif option3 == "3":
                    break
                elif option3 == "4":
                    option = "3"
                    option2 = "5"
                    break
                else:
                    print(y)
        if option2 == "4":
            break
        if option2 == "5":
            option = "3"
            break
        else:
            print(y)
            option2 = "4"


if __name__ == "__main__":
    while True:
        print("\n"
              "==============================>>\n"
              "| 1. Sign up \n"
              "| 2. Login \n"
              "| 3. exit programme \n"
              "==============================>>\n")
        option = input(">> ")
        if option == "1":
            x = User_Account_Handler().sign_up()
            print(x, "\n")
            if x == "Account Successfully created!!":
                options_mechanism()
        if option == "2":
            x = User_Account_Handler().login()
            print(x, "\n")
            if x == "Login Successfully!!":
                options_mechanism()
        if option == "3":
            print("Thanks for trying this program")
            break
        if (option == "1" or option == "2") and x in (
                "Username cannot bare a symbol or space(s)",
                "Password length too short",
                "Password doesn't match",
                "Username already exist",
                "Invalid Credentials"
        ):
            pass
        else:
            print(y)
