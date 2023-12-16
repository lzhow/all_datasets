import matplotlib.pyplot as plt

def average(data):
    return sum(data) / len(data)

def median(data):
    sorted_data = sorted(data)
    n = len(data)
    mid = n // 2
    if n % 2 == 0:
        return (sorted_data[mid - 1] + sorted_data[mid]) / 2
    else:
        return sorted_data[mid]

def visualize_data(data):
    avg = average(data)
    med = median(data)
    plt.plot(data, label='Data')
    plt.axhline(y=avg, color='r', linestyle='-', label=f'Average: {avg}')
    plt.axhline(y=med, color='g', linestyle='-', label=f'Median: {med}')
    plt.legend()
    plt.show()

data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
visualize_data(data)
