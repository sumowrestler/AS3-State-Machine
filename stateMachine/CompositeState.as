package stateMachine
{
	public class CompositeState implements IState
	{
		public var _name : String;
		public var _fromCount : Vector.<int>;
		public var _from : Array;
		public var _enter : Vector.<Function>;
		public var _exit : Vector.<Function>;
		public var _parent : IState;
		public var _queriedFromIndex : int;
		public var _children : Array;
		public var _parentName : String;

		public function CompositeState(stateName : String, params : Array, parent : State = null)
		{
			this.children = [];
			_from = [];
			_fromCount = new Vector.<int>();
			_enter = new Vector.<Function>();
			_exit = new Vector.<Function>();

			this._name = stateName;

			for (var i : int = 0; i < params.length; i++)
			{
				if (!params[i].from) params[i].from = "*";
				_from.push(params[i].from);
				if (_from is Array)
				{
					_fromCount.push(_from.length);
				}
				else if (_from is String)
				{
					_fromCount.push(1);
				}
				_enter.push(params[i].enter);
				_exit.push(params[i].exit);
			}
		}

		public function init(stateMachine : StateMachine) : void
		{
			if (parentName) parent = stateMachine.states[parentName] as IState;
		}

		public function flattenArray(array : Array) : Array
		{
			var flattened : Array = new Array();
			for each (var item:* in array)
			{
				if (item is Array)
				{
					flattened = flattened.concat(flattenArray(item));
				}
				else
				{
					flattened.push(item);
				}
			}
			return flattened;
		}

		public function mapCompositeState(nextIndex : int = 0, sum : int = 0) : int
		{
			sum += _fromCount[nextIndex];
			trace(sum, _queriedFromIndex);
			if (sum >= _queriedFromIndex)
			{
				return _fromCount[nextIndex] as int;
			}
			else
			{
				mapCompositeState(nextIndex++, sum);
			}
			return -1;
		}

		public function allowTransitionFrom(stateName : String) : Boolean
		{
			_queriedFromIndex = from.indexOf(stateName);
			return (_queriedFromIndex != -1);
		}

		public function get name() : String
		{
			return _name;
		}

		public function get from() : Object
		{
			return flattenArray(_from);
		}

		public function get enter() : Function
		{
			return _enter[mapCompositeState()];
		}

		public function get exit() : Function
		{
			return _exit[mapCompositeState()];
		}

		public function set parent(parent : IState) : void
		{
			_parent = parent;
			_parent.children.push(this);
		}

		public function get parent() : IState
		{
			return _parent;
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