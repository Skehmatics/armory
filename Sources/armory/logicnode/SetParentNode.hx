package armory.logicnode;

import iron.object.Object;
import armory.trait.physics.RigidBody;

class SetParentNode extends LogicNode {

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function run(from: Int) {
		var object: Object = inputs[1].get();

		var parent: Object;
		var isUnparent = false;

		if (Std.isOfType(inputs[2].fromNode, ObjectNode)) {
			var parentNode = cast(inputs[2].fromNode, ObjectNode);
			isUnparent = parentNode.objectName == "";
		}
		if (isUnparent) parent = iron.Scene.active.root;
		else parent = inputs[2].get();

		if (object == null || parent == null || object.parent == parent) return;

		object.parent.removeChild(object, isUnparent); // keepTransform

		#if arm_physics
		var rigidBody = object.getTrait(RigidBody);
		if (rigidBody != null) rigidBody.setActivationState(0);
		#end

		parent.addChild(object, !isUnparent); // applyInverse

		runOutput(0);
	}
}
