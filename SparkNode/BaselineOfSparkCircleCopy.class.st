Class {
	#name : #BaselineOfSparkCircleCopy,
	#superclass : #BaselineOf,
	#category : #BaselineOfSparkCircleCopy
}

{ #category : #baselines }
BaselineOfSpyLite >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'SparkNode'
    ]
]
