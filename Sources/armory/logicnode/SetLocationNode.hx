package armory.logicnode;

import iron.object.Object;
import iron.math.Vec4;
import armory.trait.physics.RigidBody;

class SetLocationNode extends LogicNode {

	var quat = new Quat();

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function run(from: Int) {
		var object: Object = inputs[1].get();
		var vec: Vec4 = inputs[2].get();
		var relative: Bool = inputs[3].get();

		if (object == null || vec == null) return;

		if (!relative) {
			vec.sub(object.parent.transform.world.getLoc()); // Remove parent location influence

			// Convert vec to parent local space
			var vec1 = new Vec4();
			vec1.x = vec.dot(object.parent.transform.right());
			vec1.y = vec.dot(object.parent.transform.look());
			vec1.z = vec.dot(object.parent.transform.up());
			vec.setFrom(vec1);
		}

		object.transform.loc.setFrom(vec);
		object.transform.buildMatrix();

		#if arm_physics
		var rigidBody = object.getTrait(RigidBody);
		if (rigidBody != null) rigidBody.syncTransform();
		#end

		runOutput(0);
	}
}
