# KnockKnock

A simple microcontroller measuring device connected to a visualization in [Processing](http://processing.org).

# TRAINS

Using the knock sensor created for my [BounceHounce](https://github.com/dandegeest/BounceHouse/tree/main/docs) project I set out to measure knocks and vibrations in the real world.  My original intent was to measure railroad train activity behind Reliable Street in Ames, IA.  I made several attempts at this by trying to measure vibrations on the building as the trains rumbled by placing it on doors, windows, floors, etc.

![image](/docs/tksensor.jpg)

However, it became apparent from these experiements that the sensor needed to be on a railroad ties or at least much closer to the train for good sensor readings.  This still resulted in some interesting visualizations.

![image](/trainframesTrial1/imageTK000005400.png)

More images
- [trial1](/trainframesTrial1)
- [trial2](/trainframesTrial2)
- [trial3](/trainframesTrial3)
- [trial4](/trainframesTrial4)
- [trial5](/trainframesTrial5)
- [trial6](/trainframesTrial6)
- [trial7](/trainframesTrial7)
- [trial8](/trainframesTrial8)

# GUITARS
The next experiment involved connecting the sensor to the body of my acoustic guitar and the playing strings, chords, and tapping rhythms on the body. This worked well and created some insteresting visuals.

![image](/guitarFrames/image000550.png)
[More](/guitarFrames)

# Visualization

For the Processing visualization I wanted to experiement with a twist on oscilloscope or other measuring device display like an EKG that has a right to left repeating read and display.  For this I created a simple system in processing the moves the drawing location from left to right and top to bottom over each frame.  I experiemented with different frame rates but peferred faster playback of 30FPS.  As the "playhead" moves the app is reading values from the sensor over the serial connection and displaying something based on the value and the current drawing rules I was testing out.  Larger values might draw a larger item for example.

See [draw()](https://github.com/dandegeest/KnockKnock/blob/7f49ee1f18f48ac79d45b253fd12eaba48f60789/MeasuringDevTrain.pde#L79) function.

 
