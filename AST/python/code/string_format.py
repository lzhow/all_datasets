# Python String Formatting Examples

name = "Alice"
age = 30
formatted_str1 = "Hello, %s. You are %d years old." % (name, age)
print(formatted_str1)

name = "Bob"
age = 25
formatted_str2 = "Hello, {}. You are {} years old.".format(name, age)
print(formatted_str2)

name = "Carol"
age = 35
formatted_str3 = f"Hello, {name}. You are {age} years old."
print(formatted_str3)

formatted_str4 = "Hello, {name}. You are {age} years old.".format(name="Dave", age=40)
print(formatted_str4)
