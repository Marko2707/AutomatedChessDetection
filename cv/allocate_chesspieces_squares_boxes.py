import numpy as np
from shapely.geometry import Polygon, Point

# Function to create a Polygon from corner coordinates
def create_polygon(corners):
    return Polygon(corners)

# Placeholder for the final allocations
field_allocations = []

# Iterate over each result in the results list
for result in results:
    # Extract the bounding boxes and class IDs for this result
    boxes = result.boxes.xyxy  # Bounding boxes in (x_min, y_min, x_max, y_max)
    class_ids = result.boxes.cls  # Class IDs
    names = result.names  # Class names
    
    # Convert the YOLO boxes to rectangles as (x_min, y_min, x_max, y_max)
    yolo_boxes = boxes.cpu().numpy()  # Move tensor to CPU and then convert to numpy array
    yolo_class_ids = class_ids.cpu().numpy()  # Class IDs
    yolo_names = [names[int(class_id)] for class_id in yolo_class_ids]  # Get class names

    # Iterate over each bounding box in the result
    for box, name in zip(yolo_boxes, yolo_names):
        x_min, y_min, x_max, y_max = box
        
        # Calculate the point at the lower middle 1/4 of the box
        box_height = y_max - y_min
        lower_mid_y = y_min + (box_height * 0.75)  # 3/4 down from the top
        lower_mid_x = (x_min + x_max) / 2  # Horizontal center remains the same

        # Create a Point object for this lower middle 1/4 position
        box_point = Point(lower_mid_x, lower_mid_y)

        allocated_field = None
        for field, corners in fields_with_corners:
            # Create a polygon from the corners of the field
            field_polygon = create_polygon(corners)
            
            # Check if the point is inside the field's polygon
            if field_polygon.contains(box_point):
                allocated_field = field
                break  # Exit once we find the field

        # Append result: which field the box belongs to, and the class of the object
        field_allocations.append((allocated_field, name))

# Print the field allocations
for allocation in field_allocations:
    print(f"Allocated field: {allocation[0]}, Object: {allocation[1]}")
