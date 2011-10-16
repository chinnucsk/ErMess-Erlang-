-type(status()   :: enabled | disabled).
-type(c_pid()   :: pid() | atom()).
-record (client, {name = unknown	:: any(),
				  status = enabled	::status(),
				  pid = unknown		:: c_pid(),
				  node = unknown	:: node()
				  }).