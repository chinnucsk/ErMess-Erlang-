%% @author Amir Almasi <amir.fireflame@gmail.com>
%% @module serverChat.erl
%% @doc the purpose of this module is, to implement a small chat system between different computers
%% @version 0.1.0.1
%% @ todo: there are alot left.
%% Created: Sep 8, 2011
-module(serverChat).

%%
%% Include files
%%
-include("client.hrl").

%%
%% Exported Functions
%%
%% -compile (export_all).
-export([init/0,loop/1,showInfo/1,terminate/0, showClients/0,showClients/1,showETS/0,sendMessage/4,testRecord/0]).

%%
%% API Functions
%%

%% @doc <html>An exported function to for the first initialization <br/> the function spawn a loop process to receive message </html>
%% @spec init() -> atom()
init() ->
	register(?MODULE, spawn(serverChat, loop, [orddict:new()])),
	?MODULE.

%%
%% Local Functions
%%

%% @doc <html> A process which will be waiting for the comming messeges </html>
%% @spec loop(list()) -> ok | true
loop (ClientList) ->
	receive
		{connect, Node, Pid} ->
%% 			io:format("The message has been received ~p ~n", [Node]),
%% 			io:format("The message has been received ~p ~n", [Pid]),
			spawn(fun () -> {clientChat, Node} ! {connected, ok} end ),
			?MODULE:loop([{Node, Pid}|ClientList]);
		{show, clients} ->
			?MODULE:showClients(ClientList),
			?MODULE:loop(ClientList);
		{message, Message, Node, Pid} ->
			io:format("A message has been recieved in {message, Message,...}~p~n", [Message]),
			spawn(fun() -> catch (?MODULE:sendMessage(Message,Node, Pid, ClientList)) end),
			?MODULE:loop(ClientList);
		{internal_message, Message} -> 
			?MODULE:showInfo(Message),
			?MODULE:loop(ClientList);
		{delivery, true} -> 
			?MODULE:showInfo("Message has been received"),
			?MODULE:loop(ClientList);
		stop -> ok;
		Unecpected -> io:format("something is wrong, one unexpected message has been received ~p~n", [Unecpected])
	end.



%% @doc <html> A function to print out the received messages </html>
%% @spec showInfo(list()) -> ok
showInfo(Message) ->
	io:format("The Message: ~p~n",[Message]).


%% @doc <html> A function to terminate the loop process by sending a message </html>
%% @spec terminate () -> ok
terminate() ->
	?MODULE ! stop, ok.

%% @doc <html> A function to send a message to the main process for asking clients list </html>
%% @spec showClients() -> ok
showClients() ->
	?MODULE ! {show, clients}, ok.

%% @doc <html> A function to get the client list and print out them one by one </html>
%% @spec showClients(list()) -> ok
showClients([])->
	ok;
showClients([{N, P}|T]) ->
	io:format("Client is: ~p  ~p ~n", [N, P]),
	?MODULE:showClients(T).

%% @doc <html> A function to start tv to show all the tables for debugging </html>
%% @spec showETS() -> ok
showETS () ->
	tv:start(), ok.


%% @doc <html> A function to send a message to a process </html>
%% @spec sendMessage(term(), node(), pid(), list()) -> ok
sendMessage(Message,Node, Pid, [{C_node, C_pid}|T]) ->
	{clientChat, C_node} ! {message, Message, from, Node, Pid},
	sendMessage(Message, Node, Pid, T);
sendMessage(_,_, _, []) ->
	throw(ok).

%% @doc <html> A method to test included record if it works properly or not </html>
%% @spec testRecord() -> record()
testRecord() ->
	#client{name = 'Amir',
			node = node()}.