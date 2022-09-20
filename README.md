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

<p align="right">
<img src="https://user-images.githubusercontent.com/59859774/191319596-370519e8-a02c-43ea-a5cb-7c2fd4c89a51.gif">
<img src="https://user-images.githubusercontent.com/59859774/191319923-db275e41-da75-4a25-b151-faef9ae17a62.gif">
</p>
