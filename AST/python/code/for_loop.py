def forloop():
    cdic = {"a": 3, "b": 2, "c": 1}
    for x in cdic:
        if x == "d":
            break
        for y in range(2, 3):
            print(x, y)
