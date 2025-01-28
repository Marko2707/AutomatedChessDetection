import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import cv2
import numpy as np

def mark_points(image_path):
    """
    Öffnet ein Bild und ermöglicht das Markieren von Punkten.
    Gibt die Pixelkoordinaten der markierten Punkte zurück.
    """
    img = mpimg.imread(image_path)
    points = []

    def onclick(event):
        if event.xdata and event.ydata:
            points.append((int(event.xdata), int(event.ydata)))
            print(f"Punkt hinzugefügt: {int(event.xdata)}, {int(event.ydata)}")

    fig, ax = plt.subplots()
    ax.imshow(img)
    plt.title("Klicke auf Punkte und schließe das Fenster, wenn du fertig bist.")
    cid = fig.canvas.mpl_connect('button_press_event', onclick)
    plt.show()
    fig.canvas.mpl_disconnect(cid)

    print("Markierte Punkte:", points)
    return points

def draw_chessboard_with_labels(image_path, corners):
    """
    Zeichnet ein beschriftetes Schachbrett auf das Originalbild.
    """
    img = cv2.imread(image_path)
    top_left, top_right, bottom_right, bottom_left = corners

    width = 800
    height = 800
    dst_points = np.float32([
        [0, 0],
        [width-1, 0],
        [width-1, height-1],
        [0, height-1]
    ])
    matrix = cv2.getPerspectiveTransform(np.float32([top_left, top_right, bottom_right, bottom_left]), dst_points)
    inverse_matrix = cv2.getPerspectiveTransform(dst_points, np.float32([top_left, top_right, bottom_right, bottom_left]))

    rows, cols = 8, 8
    cell_width = width // cols
    cell_height = height // rows

    columns = "ABCDEFGH"
    labels = [f"{col}{row}" for row in range(1, rows + 1) for col in columns]

    for i in range(rows):
        for j in range(cols):
            top_left_cell = (j * cell_width, i * cell_height)
            bottom_right_cell = ((j + 1) * cell_width, (i + 1) * cell_height)
            center_cell = (
                (top_left_cell[0] + bottom_right_cell[0]) // 2,
                (top_left_cell[1] + bottom_right_cell[1]) // 2,
            )
            center_original = cv2.perspectiveTransform(
                np.array([[center_cell]], dtype=np.float32), inverse_matrix
            )[0][0]

            label = labels[i * cols + j]
            cv2.putText(
                img,
                label,
                tuple(center_original.astype(int)),
                fontFace=cv2.FONT_HERSHEY_SIMPLEX,
                fontScale=0.5,
                color=(0, 0, 255),
                thickness=1,
                lineType=cv2.LINE_AA,
            )

    for i in range(1, rows):
        start_point = (0, i * cell_height)
        end_point = (width, i * cell_height)
        start_original = cv2.perspectiveTransform(np.array([[start_point]], dtype=np.float32), inverse_matrix)[0][0]
        end_original = cv2.perspectiveTransform(np.array([[end_point]], dtype=np.float32), inverse_matrix)[0][0]
        cv2.line(img, tuple(start_original.astype(int)), tuple(end_original.astype(int)), (0, 255, 0), 2)

    for j in range(1, cols):
        start_point = (j * cell_width, 0)
        end_point = (j * cell_width, height)
        start_original = cv2.perspectiveTransform(np.array([[start_point]], dtype=np.float32), inverse_matrix)[0][0]
        end_original = cv2.perspectiveTransform(np.array([[end_point]], dtype=np.float32), inverse_matrix)[0][0]
        cv2.line(img, tuple(start_original.astype(int)), tuple(end_original.astype(int)), (255, 0, 0), 2)

    cv2.imshow("Beschriftetes Schachbrett", img)
    cv2.imwrite("output_labeled_chessboard.jpg", img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

# Bildpfad definieren und Punkte markieren
image_path = "Chessboard recognition/test10.jpg"
points = mark_points(image_path)

# Sicherstellen, dass vier Punkte markiert wurden
if len(points) == 4:
    draw_chessboard_with_labels(image_path, points)
else:
    print("Bitte genau 4 Punkte markieren!")
