var React = require('react');
var $ = require('jquery');

var Component = React.createClass({
  getInitialState: function () {
    return {
      candidates: [],
      currentPage: 0
    };
  },

  getDefaultProps: function () {
    return {
      url: '/candidates',
      pageSize: 20
    }
  },

  render: function () {
    var start = this.state.currentPage * this.props.pageSize;
    var end = start + this.props.pageSize;

    return (
      <div>
        <table className="table">
          <thead>
            <tr>
              <th>Profile</th>
              <th>Location</th>
              <th>Skills</th>
            </tr>
          </thead>
          <tbody>
            {
              this.state.candidates.slice(start, end).map(function(candidate) {
                return (
                  <tr>
                    <td><a href="/user/{candidate.id}">{candidate.name}</a></td>
                    <td>{ candidate.location }</td>
                  </tr>
                );
              })
            }
          </tbody>
        </table>
        <br />
        <button onClick={this.nextPage} >Next page</button>
        <button onClick={this.previousPage}>Previous page</button>
      </div>
    );
  },

  nextPage: function(event) {
    var lastPage = Math.floor(this.state.candidates.length / this.props.pageSize);

    if (this.state.candidates.length == 0 || (this.state.currentPage >= lastPage)) {
      return;
    }
    this.setState({
      currentPage: this.state.currentPage + 1
    });
  },

  previousPage: function(event) {
    if (this.state.candidates.length == 0 || this.state.currentPage == 0) {
      return;
    }

    this.setState({
      currentPage: this.state.currentPage - 1
    })
  },

  componentDidMount: function () {
    $.ajax({
      url: this.props.url,
    }).then(function(data) {
      if (this.isMounted()) {
        this.setState({
          candidates: data
        });
      }
    }.bind(this));
  }
});

React.render(<Component pageSize={15} />, document.getElementById('content'));
