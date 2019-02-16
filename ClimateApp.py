from flask import Flask, jsonify, render_template, request

app = Flask(__name__)

import datetime as dt

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func, inspect, distinct, desc

engine = create_engine("sqlite:///hawaii.sqlite")

Base = automap_base()

Base.prepare(engine, reflect=True)

Measurement = Base.classes.measurement
Station = Base.classes.station

session = Session(engine)

#start_date = input("Enter Start Date (YYYY-MM-DD):")
#end_date = input("Enter End Date (YYYY-MM-DD):")


@app.route("/")
def home():

    homepage = """
        <html>
            <h3 align="center"> Climate App </h3>
            </br>
            </br>
            <p >Available APIs</br>
                <ul>
                    <li>/api/v1.0/precipitation</li>
                    <li>/api/v1.0/stations</li>
                    <li>/api/v1.0/tobs</li>
                    <li>/api/v1.0/start</li>
                    <li>/api/v1.0/start/end</li>
                    <li>/api/v1.0/daterangeform</li>
                </ul>
            </p>                
        </html>
        """
    return homepage

@app.route("/api/v1.0/precipitation")
def precipitation():

    preceipation = session.query(Measurement.date, Measurement.prcp).all()

    precip_dict = dict(preceipation)

    return jsonify(precip_dict)

@app.route("/api/v1.0/stations")
def stations():

    stations = session.query(Measurement.station).\
        group_by(Measurement.station).all()

    return jsonify(stations)

@app.route("/api/v1.0/tobs")
def tobs():

    date_last = session.query(func.max(Measurement.date)).first()
    
    year_ago = dt.datetime.strptime(date_last[0], "%Y-%m-%d") - dt.timedelta(days=365)

    past_year = session.query(Measurement.date, Measurement.tobs).\
                filter(Measurement.date >= year_ago).all()

    past_year_tobs_dict = dict(past_year)

    return jsonify(past_year_tobs_dict)

start_date = input("Enter Start Date (YYYY-MM-DD):")
end_date = input("Enter End Date (YYYY-MM-DD):")

@app.route("/api/v1.0/<start_date>")
def start_date(start_date):

    if start_date != "" and end_date == "":
        min_temp = session.query(func.min(Measurement.tobs)).\
            filter(Measurement.date >= start_date).first()
        max_temp = session.query(func.max(Measurement.tobs)).\
            filter(Measurement.date >= start_date).first()
        avg_temp = session.query(func.avg(Measurement.tobs)).\
            filter(Measurement.date >= start_date).first()
        data_result2 = "Min Temp = " + str(min_temp[0]) +"</br>" + "Average Temp = " + str(avg_temp[0]) +"</br>" + "Max Temp = " + str(max_temp[0])

    return data_result2

@app.route("/api/v1.0/<start_date>/<end_date>")
def start_end(start_date,end_date):

    if start_date != "" and end_date != "":
        min_temp = session.query(func.min(Measurement.tobs)).\
            filter(Measurement.date >= start_date).\
            filter(Measurement.date <= end_date).first()
        max_temp = session.query(func.max(Measurement.tobs)).\
            filter(Measurement.date >= start_date).\
            filter(Measurement.date <= end_date).first()
        avg_temp = session.query(func.avg(Measurement.tobs)).\
            filter(Measurement.date >= start_date).\
            filter(Measurement.date <= end_date).first()
        data_result3 = "Min Temp = " + str(min_temp[0]) +"</br>" + "Average Temp = " + str(avg_temp[0]) +"</br>" + "Max Temp = " + str(max_temp[0])
    
        return data_result3



@app.route("/api/v1.0/daterange", methods=["POST", "GET"])
def range():

    if request.method == "GET":
        return render_template("dateform.html")

    elif request.method == "POST":
    
        start_date = request.form["StartDateForm"]
        end_date = request.form["EndDateForm"]

        if start_date != "" and end_date == "":
            min_temp = session.query(func.min(Measurement.tobs)).\
                filter(Measurement.date >= start_date).first()
            max_temp = session.query(func.max(Measurement.tobs)).\
                filter(Measurement.date >= start_date).first()
            avg_temp = session.query(func.avg(Measurement.tobs)).\
                filter(Measurement.date >= start_date).first()
            data_result = "Min Temp = " + str(min_temp[0]) +"</br>" + "Average Temp = " + str(avg_temp[0]) +"</br>" + "Max Temp = " + str(max_temp[0])
        
        elif start_date != "" and end_date != "":
            min_temp = session.query(func.min(Measurement.tobs)).\
                filter(Measurement.date >= start_date).\
                filter(Measurement.date <= end_date).first()
            max_temp = session.query(func.max(Measurement.tobs)).\
                filter(Measurement.date >= start_date).\
                filter(Measurement.date <= end_date).first()
            avg_temp = session.query(func.avg(Measurement.tobs)).\
                filter(Measurement.date >= start_date).\
                filter(Measurement.date <= end_date).first()
            data_result = "Min Temp = " + str(min_temp[0]) +"</br>" + "Average Temp = " + str(avg_temp[0]) +"</br>" + "Max Temp = " + str(max_temp[0])
        
        return data_result

if __name__ == "__main__":

    app.run(debug=True)