usage: colonies = findcolonies(fname)

input:
  required
    fname        a string of input file file name

  optional
    difference    intensity difference between two circles
    s             percentage/100 of increase or decrease of radius to reduce sensitivity (0,1)
    radiibound    lower and upper bounds on the detected radii, number of pixels
    edgethreahold lower and upper bounds of the thresholds of edge detector, (0,1)
    kernelwidth   kernel width of the Gaussian filter for edge detection, positive integer
    sensitivity   sensitivity of circle detector, (0,1)

outputs
  colonies        a struct array, each struct has the following attributes

                  center1     x,y coordinates (top left corner is the origin, x-axis points
                              to the right, y-axis points down)
                  radius1     radius of first circle, integer number of pixels
                  medval1     median intensity value of the first circle, integer
                  center2     x,y coordinates of the second circle
                  radius2     radius of the second circle
                  medval2     median intensity value of the second circle
                  bigcenter   x,y coordinates of the interface circle
                  bigradius   radius of the the interface circle

Example:
colonies = findcolonies('./data/P1-5869-20002.tif')

returns
>> colonies
struct with fields:

    center1: [289.7008 524.8523]
    radius1: 76
    medval1: 49
    center2: [182.1208 553.3790]
    radius2: 85
    medval2: 104
  bigcenter: [1.8910e+04 -3.6430e+03]
  bigradius: 1.9132e+04


colonies = findcolonies('./data/P1-5869-50005.tif','s',0.15)
returns
>> colonies(1)
  struct with fields:

      center1: [150.1492 782.5172]
      radius1: 85
      medval1: 111
      center2: [116.4754 891.1437]
      radius2: 73
      medval2: 47
    bigcenter: [785.5060 -905.6220]
    bigradius: 1.8663e+03

>> colonies(2)
  struct with fields:

      center1: [1.7417e+03 239.4748]
      radius1: 122
      medval1: 113
      center2: [1.7053e+03 176.6376]
      radius2: 103
      medval2: 40
    bigcenter: [1.5802e+03 -22.0380]
    bigradius: 264.1140
