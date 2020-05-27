// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React, {Fragment} from 'react'
import {ActionCableProvider} from 'react-actioncable-provider';
import {API_WS_ROOT} from './constants';

import CatsGame from './components/CatsGame';
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'


function uuidv4() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}


document.addEventListener('DOMContentLoaded', () => {
    fetch('/cats_games/2/current_state').then(res => res.json())
        .then(response => {
        ReactDOM.render(
            <ActionCableProvider url={API_WS_ROOT}>
                <CatsGame gameData={response}/> </ActionCableProvider>,
            document.body.appendChild(document.createElement('div')),
        )
    });
})
