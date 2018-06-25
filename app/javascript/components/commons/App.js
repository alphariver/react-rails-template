import React, { Component } from 'react'
import { DevView } from './index.js'
import 'babel-polyfill'

class App extends Component {

  constructor(props) {
    super(props)
  }

  render() {
    return (
        <div className="container">
            {this.props.children}
            <DevView props={this.props.appProps} />
        </div>
    )
  }
}

export default App;
