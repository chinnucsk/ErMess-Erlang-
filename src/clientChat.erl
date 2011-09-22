%% @author Amir Almasi <amir.fireflame@gmail.com>
%% @module clientChat.erl
%% @doc the purpose of this module is, to implement a small chat system for the client part to communicate with server
%% @version 0.1.0.1
%% @ todo: there are alot left.
%% Created: Sep 10, 2011
-module(clientChat).

%%
%% Include files
%%

%%
%% Exported Functions
%%
%% -export([]).
-compile (export_all).

%%
%% API Functions
%%

%% @doc <html>An exported function for the first initialization <br/> the function spawn a loop process to receive message </html>
%% @spec init() -> pid()
init() ->
	register(?MODULE, spawn(clientChat, loop, [])),
	?MODULE.

%% @doc <html> A process which will be waiting for the comming messeges </html>
%% @spec loop() -> ok | true
loop () ->
	receive
		connect -> 
			io:format("hey connect~n", []),
			spawn(?MODULE, connect, []),
			?MODULE:loop();
		{message, Message}->
			io:format("hey message~n", []),
			spawn(?MODULE, sendMessage, [Message]),
			?MODULE:loop();
		{connected,ok} ->
			io:format("Connected!!~n"),
			spawn(fun() -> {clientSof, 'java@Amir-PC'} ! {connected, ok} end),
			?MODULE:loop();
		{message, Message, from, Node, Pid} -> 
			showInfo(Message, Node, Pid),
			spawn(fun() -> {clientSof, 'java@Amir-PC'} ! {message, Message} end),
			?MODULE:loop();	
		Unecpected -> io:format("something is wrong, one unexpected message has been received ~p~n", [Unecpected])
	end.

showInfo(Message, Node, Pid) ->
	io:format("~p , form: ~p, ~p", [Message, Node, Pid]), ok.

%% @doc <html> A function to send the desired message to the server</html>
%% @spec sendMessage(any()) -> ok
sendMessage(Message) ->
	{serverChat, 'chat@Amir-PC'} ! {message, Message, node(), self()}, ok.

%% @doc <html> A function to connect to the server to be prepared for chatting</html>
%% @spec connect() -> ok
connect() ->
	{serverChat, 'chat@Amir-PC'} ! {connect, node(), self()}, ok.


%%
%% Local Functions
%%

