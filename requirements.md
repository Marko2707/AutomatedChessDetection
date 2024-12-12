# Chessboard Recognition System Requirements

## 1. General Requirements
- Users can take a photo of a chessboard.
- The system shall recognize the board and piece positions from the photo.
- Recognized positions shall be converted into FEN (Forsyth-Edwards Notation).
- FEN notation shall be sent to a chess engine to suggest the best move.
- Suggested moves and the board state shall be displayed in a user-friendly interface.
- Chess games can be saved and loaded from a database.
- The system shall work on both Android and iOS.

## 2. Functional Requirements

### Image Processing
- User captures chessboard images using the device camera.
- The application detects the chessboard and pieces in the image.
- The application adjusts the picture from the user to match lighting conditions and camera angles for better accuracy.

### Chessboard and Piece Recognition
- The machine learning model shall identify standard chessboard patterns and dimensions.
- The machine learning model shall distinguish pieces by type (e.g., pawn, knight) and color (black or white).

### FEN Conversion
- The application shall convert the recognized board state into valid FEN notation.

### Chess Engine Integration
- The application shall use the Stockfish engine to suggest the best moves based on FEN.
- The application shall support lighter engines for local processing if needed.

### User Interface
- The application shall display the chessboard and recommended moves visually.
- The application shall highlight potential opponent moves after each user move.
- The application shall include undo/redo functionality for move history.
- The application shall allow manual board state editing for corrections.

### Simulation
- The application shall simulate standard 8x8 chessboards with accurate square dimensions and colors.
- The application shall support for various piece designs to ensure variety.
- The application shall simulate random or predefined board states, including opening, middle game, and endgame positions.
- The application shall implement varied lighting conditions.
- The application shall simulate camera views from different angles.

### Game Management
- The application shall save chess games with unique IDs.
- The application shall load previously saved games for review or continuation by request from the user.

## 3. Non-Functional Requirements
- The machine learning model shall achieve at least 90% image recognition accuracy after training.
- The machine learning model shall process images and provide recommendations in under 2 seconds under optimal circumstances.
- The application shall follow design guidelines for Android and iOS platforms.
- The imagie recognition should handle various chessboard and piece designs consistently.

## 4. Data Requirements
- Use annotated datasets, including Roboflow and user-created datasets.
- Include diverse chessboard and piece designs for better generalization.
- Support dataset augmentation with tools like Pillow and Blender.

## 5. User and System Interactions

### User Goals
- User should analyze chess games using board images.
- User should Receive next-move suggestions and win probabilities.
- User should Save, load, and review games easily.

### System Operations
- The machine learning model should analyze board images within 2 seconds.
- The application should clearly display the best move and possible opponent responses.

## 6. Challenges and Risk Mitigation

### Predicted Challenges
- **Board Recognition Accuracy**: Achieve >90% accuracy for unconventional designs.
- **Lighting Conditions**: Use preprocessing to handle poor lighting.
- **Special Rules**: Recognize en passant and castling in FEN conversion.

### Encountered Challenges
- TBD (as they arise).

## 7. Development Requirements

### Team Roles
- **Project Manager**: Ensure timely progress and schedule adherence.
- **Simulation Team**: Create annotated data with tools like Blender.
- **Computer Vision Team**: Develop the recognition module and train models.
- **Backend Team**: Handle chess engine integration and data storage.
- **Frontend Team**: Design and build the user interface.

### Performance Goals
- (TBD)

## 8. Verification and Validation

### Verification
- The developers should test recognition accuracy with a diverse set of chessboard images.
- The developers should ensure FEN notation is correct via chess engine compatibility checks.

### Validation
- The developers should conduct usability tests with chess enthusiasts to refine the interface.
- The developers should test game-saving features to confirm saved states match live games.

## 9. Use Case Diagramm
![Alt text](use_case_diagramm_02122024.png)

## Formale Use Case
| Field                | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| Goal                | User wants to get the next move suggestion by taking a photo of the chessboard with the app. |
| Primary Actor       | User                                                                        |
| Scope               | Piece recognition with computer vision and next move suggestion.           |
| Level               | User                                                                        |
| Precondition        | User takes a photo with the camera through the app.                        |
| Success End         | Chessboard is correctly detected, and the next move is suggested.          |
| Failure End         | Photo cannot be analyzed.                                                  |
| Trigger             | User takes a photo through the app.                                        |
| Main success scenario | 1. User clicks on "take a photo" button                                  |
|                        | 2. User takes a photo of a chessboard                                |
|                        | 3. System detects the board, scans it, and displays it                |
|                        | 4. User corrects any errors on the board and edits other details     |
|                        | 5. User confirms the board                                               |
|                        | 6. System suggests best next move                                        |
| Extensions (error scenarios)|   3a. Board not detected                                            |
|                        |System asks the user to retake the photo from a better angle             |
| Variations (alternative scenarios)|   4. User confirms immediately                             




