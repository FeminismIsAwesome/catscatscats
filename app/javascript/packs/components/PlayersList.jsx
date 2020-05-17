import React from "react";
import LitterboxImage from 'images/litterbox.png';
import CatnipImage from 'images/catnip.png';
import ToyImage from 'images/cattoy.png';
import FoodImage from 'images/money.png';

class PlayersList extends React.Component {
    render = () => {
        const {players} = this.props;
        return players.map((player) => {
            return (<div key={player.id} className="u-border">
                <h3>
                    {player.name} ({player.remote_id})
                </h3>
                <div className="u-flex">
                    <div><img className="player-cat-icon" src={FoodImage}/> {player.food} </div>
                    <div><img className="player-cat-icon" src={ToyImage}/> {player.toys} </div>
                    <div><img className="player-cat-icon" src={CatnipImage}/> {player.catnip} </div>
                    <div><img className="player-cat-icon" src={LitterboxImage}/> {player.litterbox} </div>

                </div>
            </div>)
        });
    }
}

export default PlayersList;