 % BSc IT Support Chatbot in Prolog

% Program Information
program_duration(bsc_it, 3). % Minimum years
program_credits(bsc_it, 90). % Total credits for BSc IT
program_credits(bschons_it, 120). % Total credits for BSc Hons IT
admission_requirement(bsc_it, 'A minimum of three pass grades in GCE A/L or equivalent').

% Level Credits
level_credits(level3, 30).
level_credits(level4, 30).
level_credits(level5, 30).
level_credits(level6, 30).

% Sample Courses (simplified from guidebook)
course('COU3200', 'Communication Skills for Computing', level3, compulsory, []).
course('COU3301', 'Database Management Systems', level3, compulsory, []).
course('COU4300', 'Object Oriented Programming', level4, compulsory, []).
course('COU4303', 'Artificial Intelligence', level4, compulsory, ['COU4201']).
course('ITU5300', 'Human Computer Interaction', level5, compulsory, []).

% Course Descriptions
course_description('COU3200', 'Introduction to communication skills in computing.').
course_description('COU4303', 'Covers fundamentals of artificial intelligence.').

% Evaluation Method
evaluation_method('If FEM >= 40, then Overall Mark = 0.4 * CAM + 0.6 * FEM.\nIf 30 <= FEM < 40, then Overall Mark = min(40, 0.4 * CAM + 0.6 * FEM).\nIf FEM < 30, then Overall Mark = FEM.').

% Grade Table
grade(85, 100, 'A+', 4.00).
grade(70, 84, 'A', 4.00).
grade(65, 69, 'A-', 3.70).
grade(60, 64, 'B+', 3.30).
grade(55, 59, 'B', 3.00).
grade(50, 54, 'B-', 2.70).
grade(45, 49, 'C+', 2.30).
grade(40, 44, 'C', 2.00).
grade(35, 39, 'C-', 1.70).
grade(30, 34, 'D+', 1.30).
grade(20, 29, 'D', 1.00).
grade(0, 19, 'E', 0.00).

% Predicates for Queries
list_courses(Level, Courses) :-
    findall(CourseCode-Title, course(CourseCode, Title, Level, _, _), Courses).

get_prerequisites(CourseCode, Prereqs) :-
    course(CourseCode, _, _, _, Prereqs).

calculate_overall_mark(CAM, FEM, Z) :-
    ( FEM >= 40 ->
        Z is 0.4 * CAM + 0.6 * FEM
    ; FEM >= 30 ->
        Z_temp is 0.4 * CAM + 0.6 * FEM,
        Z is min(40, Z_temp)
    ; Z is FEM
    ).

get_grade(Mark, Grade, GPV) :-
    grade(Min, Max, Grade, GPV),
    Mark >= Min, Mark =< Max.

% Main Chatbot Loop
chatbot :-
    write('Welcome to the BSc IT Support Chatbot.'), nl,
    write('Please select an option:'), nl,
    write('1. Program duration'), nl,
    write('2. Admission requirements'), nl,
    write('3. Courses at a specific level'), nl,
    write('4. Prerequisites for a course'), nl,
    write('5. Calculate overall mark and grade'), nl,
    write('6. Evaluation method'), nl,
    write('7. Exit'), nl,
    read(Choice),
    handle_choice(Choice).

% Handle User Choices
handle_choice(1) :-
    program_duration(bsc_it, Duration),
    write('The BSc IT program requires a minimum of '), write(Duration), write(' academic years.'), nl,
    chatbot.

handle_choice(2) :-
    admission_requirement(bsc_it, Req),
    write('Admission requirements: '), write(Req), nl,
    chatbot.

handle_choice(3) :-
    write('Enter the level (e.g., level3): '), read(Level),
    list_courses(Level, Courses),
    ( Courses = [] ->
        write('No courses found for that level.'), nl
    ; write('Courses at '), write(Level), write(':'), nl,
      print_courses(Courses)
    ),
    chatbot.

handle_choice(4) :-
    write('Enter the course code (e.g., COU4303): '), read(Code),
    ( get_prerequisites(Code, Prereqs) ->
        write('Prerequisites for '), write(Code), write(': '), write(Prereqs), nl
    ; write('Course not found or no prerequisites.'), nl
    ),
    chatbot.

handle_choice(5) :-
    write('Enter your CAM (Continuous Assessment Mark): '), read(CAM),
    write('Enter your FEM (Final Examination Mark): '), read(FEM),
    calculate_overall_mark(CAM, FEM, Z),
    get_grade(Z, Grade, GPV),
    write('Your overall mark is '), write(Z),
    write(', which corresponds to grade '), write(Grade),
    write(' with GPV '), write(GPV), nl,
    chatbot.

handle_choice(6) :-
    evaluation_method(Method),
    write('Evaluation method:'), nl,
    write(Method), nl,
    chatbot.

handle_choice(7) :-
    write('Thank you for using the BSc IT Support Chatbot. Goodbye!'), nl.

handle_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    chatbot.

% Helper to Print Courses
print_courses([]).
print_courses([Code-Title|Rest]) :-
    write(Code), write(' - '), write(Title), nl,
    print_courses(Rest).

% Start the chatbot
:- initialization(chatbot).
