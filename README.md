# iQuiz
INFO 449 HW7-9: iQuiz

Part 1

Basic interaction

- we need a TableView for the quizzes
- each element will lead the user to a list of questions
- so we start with the TableView filled with subjects
  - use Mathematics, Marvel Super Heroes, and Science
  - for now, use an in-memory array
  - make sure to build this as a UITableViewSource
 

TableView cells

- icon on the left (any image works)
- subject: title (30 characters)
- description: short sentence
 

ToolBar across the top

- put a button on the Toolbar, title it "Settings"
- "Settings" should (for now) pop a UIAlertController
- have it read "Settings go here"/"OK"

Part 2

Quizzes

- when the user selects a quiz, take them to the first "question" scene
- when the user selects an answer in the "question" scene, take them to the "answer" scene
- when the user pushes "next" from the "answer" scene...
  - ... if there are more questions, take them to the next "question" scene
  - ... if there are no questions left, take them to the "finished" scene
- when the users pushes the "back" button, they go back to the main list of topics 

"Question" scene
- UI elements required
  - question text
  - four answer possibilities (only one of which can be selected)
  - a "submit" button to indicate they are ready to go on
  - layout is totally up to you

"Answer" scene
- UI elements required
  - question text
  - the correct answer text
  - some indicator whether they got it right or wrong
  - a "next" button to indicate they are ready to go on
  - layout is totally up to you

"Finished" scene
- UI elements required
  - some kind of descriptive text ("Perfect!" "Almost!" etc)
  - the user's score on the quiz (x of y correct)
  - a "Return/Back" button to indicate they are ready to go on
  - layout is totally up to you
