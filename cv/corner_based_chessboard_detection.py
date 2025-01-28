import matplotlib.pyplot as plt
import matplotlib.image as mpimg

import cv2
import numpy as np

# TODO: Use the correct corners
# TODO: Improve corner selection (stop after 4 and make it usable for phones)
# TODO: Make sure the user picks A1 or alternatively automate it

# Change filepath to the image you want to transform and get the squares
image_path = "C:/Users/marko/Downloads/test.png/"

def mark_points(image_path):
    """
    Opens the image and lets the user select the corners.
    
    :param image_path: path to the image
    :return: list of marked points as coordinates
    """
    # Load the image
    img = mpimg.imread(image_path)

    # Initialize list for points
    points = []

    # Callback function for mouse click
    def onclick(event):
        # Only store on left-click
        if event.xdata and event.ydata:
            points.append((int(event.xdata), int(event.ydata)))
            print(f"Point added: {int(event.xdata)}, {int(event.ydata)}")

    # Display the image
    fig, ax = plt.subplots()
    ax.imshow(img)
    plt.title("Click on points and close the window when done.")
    
    # Connect mouse event
    cid = fig.canvas.mpl_connect('button_press_event', onclick)
    
    plt.show()
    # Disconnect event
    fig.canvas.mpl_disconnect(cid)

    print("Marked points:", points)
    return points

# Example call
points = mark_points(image_path)
print("Final coordinates:", points)


def draw_chessboard_on_original(image_path, corners):
    """
    Draws the chessboard on the original image based on the selected corners.
    The lines are correctly projected back onto the original image.
    
    :param image_path: path to the image
    :param corners: list of 4 marked points [(A1), (H1), (H8), (A8)]
    """
    img = cv2.imread(image_path)

    # Define corners
    top_left, top_right, bottom_right, bottom_left = corners

    # Define target coordinates for top-down view (chessboard from bird's eye view)
    width = 800  # desired width of the chessboard
    height = 800  # desired height of the chessboard
    dst_points = np.float32([
        [0, 0],  # Top-left
        [width-1, 0],  # Top-right
        [width-1, height-1],  # Bottom-right
        [0, height-1]  # Bottom-left
    ])

    # Compute perspective transformation matrix
    matrix = cv2.getPerspectiveTransform(np.float32([top_left, top_right, bottom_right, bottom_left]), dst_points)

    # Compute inverse perspective transformation matrix (for back-projection)
    inverse_matrix = cv2.getPerspectiveTransform(dst_points, np.float32([top_left, top_right, bottom_right, bottom_left]))

    # Calculate cell size for the corrected chessboard
    rows, cols = 8, 8
    cell_width = width // cols
    cell_height = height // rows

    # Draw the corrected chessboard (on the transformed image)
    transformed_img = cv2.warpPerspective(img, matrix, (width, height))

    # Draw lines on the transformed image (correct view)
    for i in range(1, rows):
        cv2.line(transformed_img, (0, i * cell_height), (width, i * cell_height), (0, 255, 0), 2)  # horizontal lines
    for j in range(1, cols):
        cv2.line(transformed_img, (j * cell_width, 0), (j * cell_width, height), (255, 0, 0), 2)  # vertical lines

    # Draw the lines back on the original image using the inverse transformation
    for i in range(1, rows):
        start_point = (0, i * cell_height)
        end_point = (width, i * cell_height)
        # Back-project the lines
        start_point_original = cv2.perspectiveTransform(np.array([[start_point]], dtype=np.float32), inverse_matrix)[0][0]
        end_point_original = cv2.perspectiveTransform(np.array([[end_point]], dtype=np.float32), inverse_matrix)[0][0]
        cv2.line(img, tuple(start_point_original.astype(int)), tuple(end_point_original.astype(int)), (0, 255, 0), 2)

    for j in range(1, cols):
        start_point = (j * cell_width, 0)
        end_point = (j * cell_width, height)
        # Back-project the lines
        start_point_original = cv2.perspectiveTransform(np.array([[start_point]], dtype=np.float32), inverse_matrix)[0][0]
        end_point_original = cv2.perspectiveTransform(np.array([[end_point]], dtype=np.float32), inverse_matrix)[0][0]
        cv2.line(img, tuple(start_point_original.astype(int)), tuple(end_point_original.astype(int)), (255, 0, 0), 2)

    # Show and save the result
    cv2.imshow("Chessboard on original image", img)
    cv2.imwrite("output_chessboard_on_original.jpg", img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

# Example call with marked corners
print("Final coordinates:", points)
draw_chessboard_on_original(image_path, points)

def get_square_corners_on_original(image_path, corners):
    """
    Computes the corners of the chessboard squares and projects them back onto the original image.
    
    :param image_path: path to the image
    :param corners: list of 4 marked points [(A1), (H1), (H8), (A8)]
    :return: list of fields with their corners [(A1, [(x1, y1), (x2, y2), ...]), (A2, [...]), ...]
    """
    img = cv2.imread(image_path)

    # Define corners
    top_left, top_right, bottom_right, bottom_left = corners

    # Define target coordinates for top-down view (chessboard from bird's eye view)
    width = 800  # desired width of the chessboard
    height = 800  # desired height of the chessboard
    dst_points = np.float32([
        [0, 0],  # Top-left
        [width-1, 0],  # Top-right
        [width-1, height-1],  # Bottom-right
        [0, height-1]  # Bottom-left
    ])

    # Compute perspective transformation matrix
    matrix = cv2.getPerspectiveTransform(np.float32([top_left, top_right, bottom_right, bottom_left]), dst_points)

    # Compute inverse perspective transformation matrix (for back-projection)
    inverse_matrix = cv2.getPerspectiveTransform(dst_points, np.float32([top_left, top_right, bottom_right, bottom_left]))

    # Calculate cell size for the corrected chessboard
    rows, cols = 8, 8
    cell_width = width // cols
    cell_height = height // rows

    # List for the fields
    fields = []

    for i in range(rows):
        for j in range(cols):
            # Calculate the corners of the current field in the transformed image
            top_left_corner = (j * cell_width, i * cell_height)
            top_right_corner = ((j + 1) * cell_width, i * cell_height)
            bottom_left_corner = (j * cell_width, (i + 1) * cell_height)
            bottom_right_corner = ((j + 1) * cell_width, (i + 1) * cell_height)
            
            # Back-project the corners onto the original image
            top_left_original = cv2.perspectiveTransform(np.array([[top_left_corner]], dtype=np.float32), inverse_matrix)[0][0]
            top_right_original = cv2.perspectiveTransform(np.array([[top_right_corner]], dtype=np.float32), inverse_matrix)[0][0]
            bottom_left_original = cv2.perspectiveTransform(np.array([[bottom_left_corner]], dtype=np.float32), inverse_matrix)[0][0]
            bottom_right_original = cv2.perspectiveTransform(np.array([[bottom_right_corner]], dtype=np.float32), inverse_matrix)[0][0]

            # Add the field with the corners
            field_label = chr(65 + j) + str(8 - i)  # A1, B1, ..., H8
            field_corners = [
                (top_left_original[0], top_left_original[1]),
                (top_right_original[0], top_right_original[1]),
                (bottom_right_original[0], bottom_right_original[1]),
                (bottom_left_original[0], bottom_left_original[1])
            ]
            fields.append((field_label, field_corners))

    return fields

def draw_squares_on_image(image_path, fields_with_corners):
    """
    Draws the chessboard square corners on the original image.
    
    :param image_path: path to the image
    :param fields_with_corners: list of fields with corners
    :return: image with drawn fields
    """
    img = cv2.imread(image_path)

    for field, corners in fields_with_corners:
        # Draw rectangles for each field
        pts = np.array(corners, np.int32)
        pts = pts.reshape((-1, 1, 2))
        cv2.polylines(img, [pts], isClosed=True, color=(0, 255, 0), thickness=2)

    # Show and save the result
    cv2.imshow("Chessboard with squares", img)
    cv2.imwrite("output_with_squares.jpg", img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


fields_with_corners = get_square_corners_on_original(image_path, points)
# Print fields and their corners
for field, corners in fields_with_corners:
    print(f"Field {field}: {corners}")

# Draw fields on the original image
draw_squares_on_image(image_path, fields_with_corners)
