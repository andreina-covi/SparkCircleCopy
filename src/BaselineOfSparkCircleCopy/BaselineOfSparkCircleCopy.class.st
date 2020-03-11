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
				package: 'SparkNode'
    ]
]
