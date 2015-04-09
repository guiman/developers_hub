var DevelopersList = React.createClass({
  getInitialState: function () {
    return {
      candidates: this.props.candidates || [],
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
                    <td><a href={"/developer/" + candidate.secure_reference}>{candidate.name}</a></td>
                    <td>{ candidate.location }</td>
                    <td>{ Object.keys(candidate.languages).length } languages</td>
                  </tr>
                );
              })
            }
          </tbody>
        </table>
        <br />
        <button className={this.props.styles.button} onClick={this.previousPage}>←</button>
        <button className={this.props.styles.button} onClick={this.nextPage} >→</button>
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
  }
});
