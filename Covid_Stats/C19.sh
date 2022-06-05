#!/usr/bin/env python3
# This is just for a practical presentation
# coded my Demiz
# This Programme enable users to check their country's live Covid 19 Statistics
# how to use? just enter the standard name of your country eg. United Kingdom and not England
# make sure you have the first letter(s) capitalized eg. Saudi Arabia
# Have fun!!!


from time import sleep

print("Please wait", end="")

import pandas as de
import matplotlib.pyplot as miz
import numpy as np

for i in range(3):
    sleep(1)
    print(".", end="")
print();
sleep(0.5)
user_country = input("country: ") or None
print()
print("Loading", end="")
if not user_country is None:
    file = de.read_csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")
    if user_country in set(file["location"]):
        file = file.set_index("location").loc[user_country].set_index("date")
    else:
        raise KeyError("ERROR!!, Invalid country's name, please reread instructions")
    new_file_column = []
    month_dict = {"01": "January", "02": "February", "03": "March", "04": "April", "05": "May", "06": "June",
                  "07": "July", "08": "August", "09": "September", "10": "October", "11": "November", "12": "December"}
    for i in file.index:
        i = i.split("-")
        year = i[0]
        month = i[1]
        x = f"{month_dict[month]}, {year}"
        if not x in new_file_column: new_file_column.append(x)
    cumulative_cases = []
    cumulative_deaths = []
    n_list = []
    for k, v in month_dict.items():
        n_list.append(v)
    n = n_list.index(new_file_column[0].replace(",", "").split()[0]) + 1
    for i in new_file_column:
        a = str(i).replace(" ", "").split(",")[-1]
        n = f"0{n}" if len(str(n)) == 1 else str(n)
        m = f"0{int(n) + 1}" if len(str(int(n) + 1)) == 1 else str(int(n) + 1)
        cumulative_cases.append(file.loc[f"{a}-{n}": f"{a}-{m}"]["new_cases"].sum())
        cumulative_deaths.append(file.loc[f"{a}-{n}": f"{a}-{m}"]["new_deaths"].sum())
        if int(n) == 12:
            n = int(n) - 12
        n = int(n) + 1
    result = de.DataFrame()
    result.index = new_file_column
    result["Cases"] = cumulative_cases
    result["Deaths"] = cumulative_deaths


class Four_Months_of_Coding:
    def Bubble_graph(self, col_type, col):
        file = de.read_csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv").set_index("location")
        col_list = []
        countries = set()
        for country in list(file.index):
            if country in "Asia,Africa,Europe,North America,South America,\
                ,World,High income,Upper middle income,Lower middle income,European Union".split(","):
                continue
            countries.add(country)
        countries = list(countries)
        for i in countries:
            col_list.append(file.loc[i][col_type].sum())
        result = de.DataFrame({f"{col}": col_list}, index=countries)
        result = result.sort_values(by=col, ascending=False).head(10)
        shorten_format = [int(str(i / 10 ** 6 if col == "Cases" else i / 1000).split(".")[0]) for i in result[col]]
        shape, chart = miz.subplots(figsize=(20, 20), facecolor="k")
        chart.pie(
            list(result[col]),
            labels=list(result.index),
            startangle=0,
            shadow=True,
            radius=0.4, 
            explode=(0.08,
                     0.06,
                     0.05,
                     0.04,
                     0.04,
                     0.04,
                     0.04,
                     0.1,
                     0.04,
                     0.04
                     ),
            autopct=lambda d: "{:.1f}{}+".format(d * sum(shorten_format) / 100, "M" if col == "Cases" else "k"),
            textprops=dict(
                color="w",
                fontsize=11.1,
                fontweight=800,
                fontstyle="normal"
            ),
            frame=True,
            labeldistance=1.09,
            pctdistance=0.7
        )
        chart.set_facecolor("k")
        miz.title(
            f"Covid 19 {col} by Country (Top 10)",
            c="w",
            pad=20,
            fontdict=dict(
                fontsize=20,
                fontweight=1000,
                fontstyle="italic"
            )
        )
        A, B, C, D, E, F, G, H, I, J = result.index
        a, b, c, d, e, f, g, h, i, j = result[col]
        shape.text(0, 0.37,
                   f"""
            | {col} Statistics
            | ------------------------------------------------->>
            | 1. {A} -- {int(a)}
            | ------------------------------------------------->>
            | 2. {B} -- {int(b)}
            | ------------------------------------------------->>
            | 3. {C} -- {int(c)}
            | ------------------------------------------------->>
            | 4. {D} -- {int(d)}
            | ------------------------------------------------->>
            | 5. {E} -- {int(e)}
            | ------------------------------------------------->>
            | 6. {F} -- {int(f)}
            | ------------------------------------------------->>
            | 7. {G} -- {int(g)}
            | ------------------------------------------------->>
            | 8. {H} -- {int(h)}
            | ------------------------------------------------->>
            | 9. {I} -- {int(i)}
            | ------------------------------------------------->>
            | 10. {J} -- {int(j)}
            | ------------------------------------------------->>
            """,
                   fontsize=12,
                   color="w"
                   )
        shape.text(0.96, 0.01, "@demiz", c="c", size=10.89, weight=10)
        shape.subplots_adjust(left=0.4, top=0.8)
        miz.show()


class User_input_manipulation:
    def cases_breakdown(self, c):
        if c.max() >= 10000000:
            c = c / 1000000
            return "Cases per Million"
        if c.max() >= 1000000:
            c = c / 100000
            return "Cases per 100k"
        if c.max() >= 100000:
            c = c / 10000
            return "Cases per 10k"
        return "Cases"

    def deaths_breakdown(self, d):
        if d.max() >= 1000000:
            d = d / 100000
            return "Deaths per 100k"
        if d.max() >= 100000:
            d = d / 10000
            return "Deaths per 10k"
        if d.max() >= 10000:
            d /= 1000
            return "Deaths per thousand"
        return "Deaths"

    def overall_graph(self, user_country):
        board = miz.figure(figsize=(20, 20))
        graph = board.add_axes([0.1, 0.14, 0.8, 0.8])
        graph.bar(result.index, result["Cases"], color="b", alpha=0.5)
        graph.bar(result.index, result["Deaths"], color="r", alpha=0.5)
        miz.xticks(rotation=45)
        miz.gca().spines["top"].set_visible(False)
        miz.gca().spines["right"].set_visible(False)
        miz.gca().spines["left"].set_bounds(0, result["Cases"].max() * 2)
        miz.title(
            f"{user_country} COVID 19 Overall Statistics",
            c="k",
            pad=15,
            fontdict=dict(
                fontsize=20,
                fontweight=1000,
                fontstyle="oblique"
            )
        )
        miz.legend(["cases", "deaths"], loc="upper left", facecolor="#cccccc", shadow=True)
        miz.ylabel(User_input_manipulation().cases_breakdown(result["Cases"]), labelpad=12, fontsize=19.1,
                   fontweight=1000)
        miz.show()

    def case_death_graph(self, name, column, color):
        case_board = miz.figure(figsize=(20, 20))
        case_graph = case_board.add_axes([0.1, 0.14, 0.8, 0.8])
        case_graph.plot(
            result.index,
            column,
            c=color,
            linestyle="-",
            linewidth=2.5,
            marker=".",
            markersize=8,
            markerfacecolor="#2222ff",
            alpha=0.5
        )
        count = 0
        for x, y in zip(result.index, column):
            arg = list(column)[count]
            arg = f"{round(arg / 1000000, 1)}M" if arg >= 1000000 else f"{round(arg / 1000, 1)}k" if arg >= 1000 else f"{int(arg)}"
            miz.annotate(arg, xy=(x, y))
            count += 1
        miz.title(
            f"{user_country} COVID 19 {name} Statistics (Total = {int(result['Cases'].sum() if name == 'Cases' else result['Deaths'].sum())})",
            c="k",
            pad=15,
            fontdict=dict(
                fontsize=20,
                fontweight=1000,
                fontstyle="oblique"
            )
        )
        miz.xticks(rotation=45)
        miz.ylabel(User_input_manipulation().cases_breakdown(
            result["Cases"]) if name == "Cases" else User_input_manipulation().deaths_breakdown(result["Deaths"]),
                   labelpad=12, fontsize=19.1, fontweight=1000)
        miz.grid(alpha=0.2)
        miz.show()


if __name__ == "__main__":
    for i in range(3):
        sleep(2.5)
        print(".", end="")
    print();
    sleep(0.5)
    if user_country == None:
        Four_Months_of_Coding().Bubble_graph("new_cases", "Cases")
        Four_Months_of_Coding().Bubble_graph("new_deaths", "Death")
        print("You can rerun the programme with a country's name as input")
    else:
        d = User_input_manipulation()
        d.overall_graph(user_country)
        d.case_death_graph("Cases", result["Cases"], "k")
        d.case_death_graph("Deaths", result["Deaths"], "r")
    print()
    print("End of Program")
    sleep(3)

