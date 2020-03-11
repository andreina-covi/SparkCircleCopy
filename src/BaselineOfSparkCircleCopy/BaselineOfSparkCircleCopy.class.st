Class {
	#name : #BaselineOfSparkCircleCopy,
	#superclass : #BaselineOf,
	#category : #BaselineOfSparkCircleCopy
}

{ #category : #baselines }
BaselineOfSparkCircleCopy >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'Roassal2'
				with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ].
		      spec
				package: 'SparkNode'
    ]
]
