"
This is a trachel shape
"
Class {
	#name : #TRSparkCircleShape,
	#superclass : #TREllipseShape,
	#instVars : [
		'sparkPaths',
		'metrics',
		'gap'
	],
	#category : #SparkNode
}

{ #category : #hooks }
TRSparkCircleShape >> computePath [
	| halfWidth halfHeight rect |
	self canvas ifNil: [ ^ nil ].
	rect := self basicEncompassingRectangle.
	halfWidth := (rect width/4 - 1) / 2 asFloat.
	halfHeight := (rect height/4 - 1) / 2 asFloat.

	path:= self athensCanvas
		createPath: [ :builder | 
			builder
				relative;
				moveTo: halfWidth negated @ 0;
				curveVia: 0 @ (halfHeight negated * 0.55)
					and: (0.45 * halfWidth) @ halfHeight negated
					to: halfWidth @ halfHeight negated;
				curveVia: (halfWidth * 0.55) @ 0 
					and: halfWidth @ (0.45 * halfHeight) 
					to: halfWidth @ halfHeight;
				curveVia: 0 @ (halfHeight * 0.55) 
					and: (0.45 * halfWidth negated) @ halfHeight 
					to: halfWidth negated @ halfHeight;
				curveVia: (halfWidth negated * 0.55) @ 0
					and: halfWidth negated @ (halfHeight negated * 0.45)
					to: halfWidth negated @ halfHeight negated ]
				
			
]

{ #category : #drawing }
TRSparkCircleShape >> computePaths [
	| angle step ratio ratio2 p1 p2 p3 p4 n |
	n := metrics size.
	n isZero
		ifTrue: [ ^ self ].
	rectangle := self basicEncompassingRectangle.
	step := (2 * 3.1415 - (n * gap)) / n.
	ratio := rectangle width / 8.
	angle := 0.
	metrics
		do: [ :sm | 
			| rdiff |
			rdiff := rectangle width / 4.
			rdiff := rdiff * sm value.
			ratio2 := ratio + rdiff.
			angle := angle + (step * 0.1).
			p1 := (ratio * angle sin) @ (ratio * angle cos).
			p2 := (ratio2 * angle sin) @ (ratio2 * angle cos).
			angle := angle + (step * 0.8).
			p3 := (ratio2 * angle sin) @ (ratio2 * angle cos).
			p4 := (ratio * angle sin) @ (ratio * angle cos).
			angle := angle + gap + (step * 0.1).
			sm
				path:
					(self athensCanvas
						createPath: [ :builder | 
							builder
								absolute;
								moveTo: p1;
								lineTo: p2;
								arcTo: p3 angle: step * 0.78 cw: false;
								lineTo: p4;
								arcTo: p1 angle: step * 0.78 cw: true;
								closePath ]) ]
]

{ #category : #drawing }
TRSparkCircleShape >> computeSignPaths [
	| angle step ratio ratio2 p1 p2 p3 p4 n |
	n := metrics size.
	n isZero
		ifTrue: [ ^ self ].
	rectangle := self basicEncompassingRectangle.
	step := (2 * 3.1415 - (n * gap)) / n.
	ratio := rectangle width / 8.
	angle := 0.
	metrics
		do: [ :sm | 
			| rdiff |
			rdiff := rectangle width / 5.
			rdiff := rdiff * sm value abs.
			ratio2 := ratio + rdiff + 3.
			p1 := (ratio * angle sin) @ (ratio * angle cos).
			p2 := (ratio2 * angle sin) @ (ratio2 * angle cos).
			angle := angle + step.
			p3 := (ratio2 * angle sin) @ (ratio2 * angle cos).
			p4 := (ratio * angle sin) @ (ratio * angle cos).
			angle := angle + gap.
			sm
				signPath:
					(self athensCanvas
						createPath: [ :builder | 
							builder
								absolute;
								moveTo: p1;
								lineTo: p2;
								arcTo: p3 angle: step cw: false;
								lineTo: p4;
								arcTo: p1 angle: step cw: true;
								closePath ]) ]
]

{ #category : #drawing }
TRSparkCircleShape >> drawOn: athensCanvas [
	self shouldBeDrawn
		ifFalse: [ ^ self ].
	athensCanvas pathTransform
		restoreAfter: [ athensCanvas pathTransform multiplyBy: matrix asFloatTransform.
			athensCanvas
				setPaint: self themedColor;
				drawShape: self path.
			"self computePaths."
			self computeSignPaths.
			self metrics
				do: [ :sm | 
					| colorcito |
					colorcito := sm value > 0
						ifTrue: [ sm color muchDarker ]
						ifFalse: [ sm color muchLighter ].
					athensCanvas
						setPaint: sm color lighter;
						drawShape: sm signPath;
						setStrokePaint: colorcito;
						draw ].
			self drawStrokeIfNecessaryOn: athensCanvas ]
]

{ #category : #initalize }
TRSparkCircleShape >> initialize [
	super initialize.
	gap := 0.13.
	metrics := OrderedCollection new
]

{ #category : #accessing }
TRSparkCircleShape >> metrics [
	^ metrics
]

{ #category : #accessing }
TRSparkCircleShape >> metrics: aOrderedCollection [
	metrics := aOrderedCollection.
	^ metrics
]
