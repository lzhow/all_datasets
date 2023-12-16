class A:
    def a(self):
        print("A.a")

    def f(self):
        print("A.f")


class B(A):
    def f(self):
        print("B.f")
