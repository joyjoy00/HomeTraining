# HomeTraining
Home personal training iOS App with PoseNet

Actually, all the project files were lost...
Someday, I'll try to restore or recreate the file!!!

With regret, I post the program execution scene.

-----------------------------------------------------------

The application is a kind of 'Personal Trainer' for everyone in their cozy home.

Input: a frame of real-time image where a person is in the exercise position.
Output: the joints of human body

With the positional information of the joint, we calculate the angle between each joint, especially the joints that are very important to the movement that he's doing.

And then, if the angles are all within the right range for performing exercise, it provides positive feedback (count + 1), or negative feedback (no count change).

*Sqaut*

<p>
<img width="25%" src="https://user-images.githubusercontent.com/59859774/191321519-4a59492c-ee55-48ad-bd3b-bb929e4f6310.gif"/>
<p/>



<p>
<img width="25%" src="https://user-images.githubusercontent.com/59859774/191320186-652f509c-40cb-4fc0-a32e-c4693902690b.gif"/>
<img width="25%" src="https://user-images.githubusercontent.com/59859774/191320855-ae978336-4032-4dac-a623-8c8693d68f96.gif"/>
<p/>
Lunge
