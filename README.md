# season-2-SE-my_sqlite
<div class="card-block">
<div class="row">
<div class="col tab-content">
<div class="tab-pane active show" id="subject" role="tabpanel">
<div class="row">
<div class="col-md-12 col-xl-12">
<div class="markdown-body">
<p class="text-muted m-b-15">
</p><h2>My Sqlite</h2>
<table>
<thead>
<tr>
<th>Technical details</th>
<th></th>
</tr>
</thead>
<tbody>
<tr>
<td>Submit files</td>
<td>my_sqlite_request. - my_sqlite_cli.</td>
</tr>
<tr>
<td>Languages</td>
<td>It needs to be completed in the language you are working on right now. If you are doing Bootcamp Javascript, then javascript (file extension will be .js). If you are doing Bootcamp Ruby, then Ruby (file extension will be .rb). It goes the same for Python, Java, C++, Rust, ...</td>
</tr>
</tbody>
</table>
<hr>
<p><strong>Part 00</strong>
Create a class called <code>MySqliteRequest</code> in <code>my_sqlite_request.rb</code>. It will have a similar behavior than a request on the real sqlite.</p>
<p>All methods, except <code>run</code>, will return an <code>instance</code> of <code>my_sqlite_request</code>. You will build the request by progressive call and execute the request by calling <code>run</code>.</p>
<p>Each row must have an ID.</p>
<p>We will do only <code>1</code> join and <code>1</code> where per request.</p>
<p><strong>Example00</strong>:</p>
<pre class=" language-plain"><code class=" language-plain">request = MySqliteRequest.new
request = request.from('nba_player_data.csv')
request = request.select('name')
request = request.where('birth_state', 'Indiana')
request.run
=&gt; [{"name" =&gt; "Andre Brown"]
</code></pre>
<p><strong>Example01</strong>:</p>
<pre class=" language-plain"><code class=" language-plain">Input: MySqliteRequest.new('nba_player_data').select('name').where('birth_state', 'Indiana').run
Output: [{"name" =&gt; "Andre Brown"]
</code></pre>
<ol start="0">
<li>Constructor
It will be prototyped:</li>
</ol>
<p><code>def initialize</code></p>
<ol>
<li>From
Implement a <code>from</code> method which must be present on each request. From will take a parameter and it will be the name of the <code>table</code>. (technically a table_name is also a filename (.csv))</li>
</ol>
<p>It will be prototyped:</p>
<p><code>def from(table_name)</code></p>
<ol start="2">
<li>Select
Implement a <code>where</code> method which will take one argument a string OR an array of string. It will continue to build the request. During the run() you will collect on the result only the columns sent as parameters to select :-).</li>
</ol>
<p>It will be prototyped:</p>
<p><code>def select(column_name)</code>
OR
<code>def select([column_name_a, column_name_b])</code></p>
<ol start="3">
<li>Where
Implement a <code>where</code> method which will take 2 arguments: column_name and value.
It will continue to build the request. During the run() you will filter the result which match the value.</li>
</ol>
<p>It will be prototyped:</p>
<p><code>def where(column_name, criteria)</code></p>
<ol start="4">
<li>Join
Implement a <code>join</code> method which will load another filename_db and will join both database on a <code>on</code> column.</li>
</ol>
<p>It will be prototyped:</p>
<p><code>def join(column_on_db_a, filename_db_b, column_on_db_b)</code></p>
<ol start="5">
<li>Order
Implement an <code>order</code> method which will received two parameters, <code>order</code> (:asc or :description) and <code>column_name</code>. It will sort depending on the <code>order</code> base on the <code>column_name</code>.</li>
</ol>
<p>It will be prototyped:</p>
<p><code>def order(order, column_name)</code></p>
<ol start="6">
<li>Insert
Implement a method to <code>insert</code> which will receive <code>a table name</code> (filename). It will continue to build the request.</li>
</ol>
<p><code>def insert(table_name)</code></p>
<ol start="7">
<li>Values
Implement a method to <code>values</code> which will receive <code>data</code>. (a hash of data on format (<code>key</code> =&gt; <code>value</code>)).
It will continue to build the request. During the run() you do the insert.</li>
</ol>
<p><code>def values(data)</code></p>
<ol start="8">
<li>Update
Implement a method to <code>update</code> which will receive <code>a table name</code> (filename). It will continue to build the request.
An update request might be associated with a <code>where</code> request.</li>
</ol>
<p><code>def update(table_name)</code></p>
<ol start="8">
<li>Set
Implement a method to <code>update</code> which will receive <code>data</code> (a hash of data on format (<code>key</code> =&gt; <code>value</code>)).
It will perform the update of attributes on all <code>matching</code> row.
An update request might be associated with a <code>where</code> request.</li>
</ol>
<p><code>def set(data)</code></p>
<ol start="9">
<li>Delete
Implement a <code>delete</code> method. It set the request to delete on all <code>matching</code> row. It will continue to build the request.
An delete request might be associated with a <code>where</code> request.</li>
</ol>
<p><code>def delete</code></p>
<ol start="10">
<li>Run
Implement a <code>run</code> method and it will execute the request.</li>
</ol>
<p><strong>Part 01</strong>
Create a program which will be a Command Line Interface (CLI) to your <code>MySqlite</code> class.
It will use <code>readline</code> and we will run it with <code>ruby my_sqlite_cli.rb</code>.</p>
<p>It will accept request with:</p>
<ul>
<li>SELECT|INSERT|UPDATE|DELETE</li>
<li>FROM</li>
<li>WHERE (max 1 condition)</li>
<li>JOIN ON (max 1 condition)
Note, you can have multiple WHERE.
Yes, you should save and load the database from a file. :-)</li>
</ul>
<p>** Example 00 ** (Ruby)</p>
<pre class=" language-plain"><code class=" language-plain">$&gt;ruby my_sqlite_cli.rb class.db
MySQLite version 0.1 20XX-XX-XX
my_sqlite_cli&gt; SELECT * FROM students;
Jane|me@janedoe.com|A|http://blog.janedoe.com
my_sqlite_cli&gt;INSERT INTO students VALUES (John, john@johndoe.com, A, https://blog.johndoe.com);
my_sqlite_cli&gt;UPDATE students SET email = 'jane@janedoe.com', blog = 'https://blog.janedoe.com' WHERE name = 'Jane';
my_sqlite_cli&gt;DELETE FROM students WHERE name = 'John';
my_sqlite_cli&gt;quit
$&gt;
</code></pre>
<p>** Example 00 ** (Javascript)</p>
<pre class=" language-plain"><code class=" language-plain">$&gt;node my_sqlite_cli.js class.db
MySQLite version 0.1 20XX-XX-XX
my_sqlite_cli&gt; SELECT * FROM students;
Jane|me@janedoe.com|A|http://blog.janedoe.com
my_sqlite_cli&gt;INSERT INTO students VALUES (John, john@johndoe.com, A, https://blog.johndoe.com);
my_sqlite_cli&gt;UPDATE students SET email = 'jane@janedoe.com', blog = 'https://blog.janedoe.com' WHERE name = 'Jane';
my_sqlite_cli&gt;DELETE FROM students WHERE name = 'John';
my_sqlite_cli&gt;quit
$&gt;
</code></pre>
<p>Our examples will use these CSV
<a href="https://storage.googleapis.com/qwasar-public/nba_player_data.csv" target="_blank">Nba Player Data</a>
<a href="https://storage.googleapis.com/qwasar-public/nba_players.csv" target="_blank">Nba Players</a></p>
<p>In addition to accomplishing this challenge. You should take a read about those concepts:</p>
<ul>
<li>B-Tree (not binary tree "B-Tree")</li>
<li>TRIE</li>
<li>Reverse Index</li>
</ul>

<p></p>
</div>

</div>
</div>
</div>
<div class="tab-pane" id="resources" role="tabpanel">
<div class="row">
<div class="col-xl-12">
<div class="row text-center">
<div class="col p-t-10 f-12">
<p>

</p>
</div>
</div>
<div class="row text-center">
<div class="col">
</div>
</div>

</div>
</div>
</div>
</div>
</div>
</div>
