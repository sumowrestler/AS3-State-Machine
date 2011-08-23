package stateMachine
{
	public class State implements IState
	{
		public var _name : String;
		public var _from : Object;
		public var _enter : Function;
		public var _exit : Function;
		public var _parent : IState;
		public var _parentName : String;
		public var _children : Array;

		public function State(stateName : String, stateData : Object = null)
		{
			this._name = stateName;

			if (stateData == null) stateData = {};

			this._from = stateData.from;
			if (!_from) _from = "*";
			this._enter = stateData.enter;
			this._exit = stateData.exit;
			this._parentName = stateData.parent;
			this.children = [];
		}

		public function init(stateMachineInstance : StateMachine) : void
		{
			if (parentName) parent = stateMachineInstance.states[parentName] as IState;
		}

		public function allowTransitionFrom(stateName : String) : Boolean
		{
			return (_from.indexOf(stateName) != -1 || from == "*");
		}

		public function get name() : String
		{
			return _name;
		}

		public function get from() : Object
		{
			return _from;
		}

		public function get enter() : Function
		{
			return _enter;
		}

		public function get exit() : Function
		{
			return _exit;
		}

		public function get parent() : IState
		{
			return _parent;
		}

		public function set parent(parent : IState) : void
		{
			_parent = parent;
			_parent.children.push(this);
		}

		public function get parentName() : String
		{
			return _parentName;
		}

		public function get parents() : Array
		{
			var parentList : Array = [];
			var parentState : IState = _parent;
			if (parentState)
			{
				parentList.push(parentState);
				while (parentState.parent)
				{
					parentState = parentState.parent;
					parentList.push(parentState);
				}
			}
			return parentList;
		}

		public function get children() : Array
		{
			return _children;
		}

		public function set children(children : Array) : void
		{
			_children = children;
		}

		public function get root() : IState
		{
			var parentState : IState = _parent;
			if (parentState)
			{
				while (parentState.parent)
				{
					parentState = parentState.parent;
				}
			}
			return parentState;
		}

		public function toString() : String
		{
			return this.name;
		}
	}
}